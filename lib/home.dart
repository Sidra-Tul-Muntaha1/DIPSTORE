import 'dart:async';

import 'package:DIPSTORE/Controller.dart/cart_controller.dart';
import 'package:DIPSTORE/Controller.dart/favourite_controller.dart';
import 'package:DIPSTORE/Controller.dart/notification_controller.dart';
import 'package:DIPSTORE/Controller.dart/product_controller.dart';
import 'package:DIPSTORE/Emptybagscreen.dart';
import 'package:DIPSTORE/Fullbagscreen.dart';
import 'package:DIPSTORE/Model.dart/Productmodel.dart';
import 'package:DIPSTORE/Productdetailscreen.dart';
import 'package:DIPSTORE/Widgets.dart/Brandrow.dart';
import 'package:DIPSTORE/Widgets.dart/fashion_image.dart';
import 'package:DIPSTORE/explore_screen.dart';
import 'package:DIPSTORE/favourites_screen.dart';
import 'package:DIPSTORE/notific.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final ProductController productController = Get.isRegistered<ProductController>()
      ? Get.find<ProductController>()
      : Get.put(ProductController());
  final CartController cartController = Get.isRegistered<CartController>()
      ? Get.find<CartController>()
      : Get.put(CartController());
  final FavouriteController favouriteController = Get.isRegistered<FavouriteController>()
      ? Get.find<FavouriteController>()
      : Get.put(FavouriteController());
  final NotificationController notificationController = Get.isRegistered<NotificationController>()
      ? Get.find<NotificationController>()
      : Get.put(NotificationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: BackButton(
  onPressed: () {
     Get.back();
  },
),
        title: Text(
          'Dipstore.',
          style: GoogleFonts.aBeeZee(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Obx(() {
            final unread = notificationController.unreadCount;
            return IconButton(
              icon: Badge(
                isLabelVisible: unread > 0,
                label: Text(
                  unread > 99 ? '99+' : '$unread',
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                backgroundColor: const Color.fromARGB(255, 36, 14, 5),
                child: const Icon(Icons.notifications_none, color: Colors.black),
              ),
              tooltip: 'Notifications',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const Notific()),
                );
              },
            );
          }),
        ],
      ),
      backgroundColor: const Color.fromARGB(255, 242, 236, 236),
      body: RefreshIndicator(
        color: Colors.brown,
        onRefresh: () => productController.fetchProducts(isRefresh: true),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hero Carousel with auto-advance every 2 seconds
              const HomeHeroCarousel(),

              // Selling Fast header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Selling fast 🔥',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Obx(() {
                      final favCount = favouriteController.count;
                      final cartCount = cartController.totalItemCount;

                      return Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const FavouritesScreen(),
                                ),
                              );
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.favorite, color: Colors.red, size: 20),
                                const SizedBox(width: 4),
                                Text(
                                  '$favCount',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Color.fromARGB(255, 36, 14, 5),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 14),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => cartController.isEmpty
                                      ? const EmptyBagScreen()
                                      : const FullBagScreen(),
                                ),
                              );
                            },
                            child: Badge(
                              isLabelVisible: cartCount > 0,
                              label: Text(
                                '$cartCount',
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              backgroundColor: const Color.fromARGB(255, 36, 14, 5),
                              child: const Icon(Icons.shopping_cart_outlined),
                            ),
                          ),
                        ],
                      );
                    }),
                  ],
                ),
              ),
              const SizedBox(height: 4),

              // Selling Fast list
              Obx(() {
                if (productController.isLoading.value &&
                    productController.products.isEmpty) {
                  return const SizedBox(
                    height: 180,
                    child: Center(
                      child: CircularProgressIndicator(color: Colors.brown),
                    ),
                  );
                }
                if (productController.errorMessage.isNotEmpty &&
                    productController.products.isEmpty) {
                  return SizedBox(
                    height: 180,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              productController.errorMessage.value,
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 13, color: Colors.red),
                            ),
                            const SizedBox(height: 8),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.brown,
                                foregroundColor: Colors.white,
                              ),
                              onPressed: () =>
                                  productController.fetchProducts(isRefresh: true),
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }
                final fastSelling = productController.fastSellingProducts;
                if (fastSelling.isEmpty) {
                  return const SizedBox(
                    height: 100,
                    child: Center(
                      child: Text(
                        'No clothing products available',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  );
                }
                return SizedBox(
                  height: 195,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: fastSelling.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      return HomeHorizontalProductCard(
                        product: fastSelling[index],
                      );
                    },
                  ),
                );
              }),

              const SizedBox(height: 16),

              // Featured brands
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: BrandRow(),
              ),

              const SizedBox(height: 8),

              // Popular products header
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                child: Text(
                  'Popular products',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // Popular products grid
              Obx(() {
                if (productController.isLoading.value &&
                    productController.products.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(32.0),
                    child: Center(
                      child: CircularProgressIndicator(color: Colors.brown),
                    ),
                  );
                }
                final popularList = productController.popularProducts;
                if (popularList.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(24.0),
                    child: Center(
                      child: Text(
                        'No clothing products available',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  );
                }
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.72,
                    mainAxisSpacing: 14,
                    crossAxisSpacing: 14,
                  ),
                  itemCount: popularList.length,
                  itemBuilder: (context, index) {
                    return HomeGridProductCard(
                      product: popularList[index],
                    );
                  },
                );
              }),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Auto-sliding Hero Carousel ───────────────────────────────────────────────

class HomeHeroCarousel extends StatefulWidget {
  const HomeHeroCarousel({super.key});

  @override
  State<HomeHeroCarousel> createState() => _HomeHeroCarouselState();
}

class _HomeHeroCarouselState extends State<HomeHeroCarousel> {
  late final PageController _pageController;
  Timer? _timer;
  int _currentPage = 0;

  final List<Map<String, dynamic>> _slides = [
    {
      'image': 'assets/coat.jpg',
      'title': 'New Season Collection',
      'subtitle': 'Winter 2025 Outerwear & Tailored Coats',
      'category': 'Jackets',
    },
    {
      'image': 'assets/image2.jpg',
      'title': 'Everyday Essentials',
      'subtitle': 'Modern Streetwear & Relaxed Hoodies',
      'category': 'Hoodies',
    },
    {
      'image': 'assets/image7.jpg',
      'title': 'Premium Fashion',
      'subtitle': 'Luxury Designer Apparel & Dresses',
      'category': 'Dresses',
    },
    {
      'image': 'assets/images3.jpg',
      'title': 'Denim & Knitwear',
      'subtitle': 'Authentic Jeans & Cozy Sweaters',
      'category': 'Jeans',
    },
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (!mounted || !_pageController.hasClients) return;
      final nextPage = (_currentPage + 1) % _slides.length;
      _pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 650),
        curve: Curves.easeInOutCubic,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      width: double.infinity,
      child: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: (idx) {
              setState(() {
                _currentPage = idx;
              });
            },
            itemCount: _slides.length,
            itemBuilder: (context, index) {
              final slide = _slides[index];
              return Stack(
                fit: StackFit.expand,
                children: [
                  // High quality background image
                  FashionImage(
                    imageUrl: slide['image'] as String,
                    fit: BoxFit.cover,
                    placeholderLabel: slide['title'] as String,
                  ),

                  // Dark gradient overlay for text readability
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.25),
                          Colors.black.withOpacity(0.65),
                        ],
                      ),
                    ),
                  ),

                  // Slide content
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          slide['title'] as String,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.aboreto(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 1.5,
                            shadows: const [
                              Shadow(
                                color: Colors.black54,
                                blurRadius: 8,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          slide['subtitle'] as String,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white70,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: const Color.fromARGB(255, 36, 14, 5),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 28,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            elevation: 2,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ExploreScreen(
                                  initialCategory: slide['category'] as String,
                                ),
                              ),
                            );
                          },
                          child: Text(
                            'Shop Now',
                            style: GoogleFonts.aBeeZee(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: const Color.fromARGB(255, 36, 14, 5),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),

          // Indicator Dots
          Positioned(
            bottom: 12,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_slides.length, (index) {
                final isActive = index == _currentPage;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  height: 6,
                  width: isActive ? 22 : 6,
                  decoration: BoxDecoration(
                    color: isActive ? Colors.white : Colors.white54,
                    borderRadius: BorderRadius.circular(3),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Horizontal Product Card ─────────────────────────────────────────────────

class HomeHorizontalProductCard extends StatelessWidget {
  final Product product;

  const HomeHorizontalProductCard({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProductDetailScreen(product: product),
          ),
        );
      },
      child: SizedBox(
        width: 120,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 120,
              width: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey[200],
              ),
              clipBehavior: Clip.antiAlias,
              child: FashionImage(
                imageUrl: product.image,
                fit: BoxFit.cover,
                placeholderLabel: product.brand,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              product.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 2),
            Text(
              product.price,
              style: const TextStyle(
                fontSize: 13,
                color: Colors.brown,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Grid Product Card ───────────────────────────────────────────────────────

class HomeGridProductCard extends StatelessWidget {
  final Product product;

  const HomeGridProductCard({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProductDetailScreen(product: product),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  FashionImage(
                    imageUrl: product.image,
                    fit: BoxFit.cover,
                    placeholderLabel: product.brand,
                  ),
                  Positioned(
                    top: 6,
                    right: 6,
                    child: Builder(builder: (context) {
                      final favController = Get.isRegistered<FavouriteController>()
                          ? Get.find<FavouriteController>()
                          : Get.put(FavouriteController());
                      return Obx(() {
                        final isFav = favController.isFavourite(product);
                        return GestureDetector(
                          onTap: () => favController.toggleFavourite(product),
                          child: CircleAvatar(
                            radius: 14,
                            backgroundColor: Colors.white.withOpacity(0.9),
                            child: Icon(
                              isFav ? Icons.favorite : Icons.favorite_border,
                              size: 16,
                              color: isFav ? Colors.red : Colors.grey,
                            ),
                          ),
                        );
                      });
                    }),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        Text(
                          product.price,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (product.oldPrice != null) ...[
                          const SizedBox(width: 6),
                          Text(
                            product.oldPrice!,
                            style: const TextStyle(
                              fontSize: 11,
                              color: Colors.grey,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}



/* import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int selectedindex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title:  Text(
        'Dipstore.',
        style: GoogleFonts.aBeeZee(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        IconButton(
          icon:  Icon(Icons.email_outlined, color: Colors.black),
          onPressed: () {},
        ),
      ],
    ),
      backgroundColor: const Color.fromARGB(255, 242, 236, 236),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Image.asset('assets/download.jpg',
                width: 700,
                height: 300,
                fit: BoxFit.cover,),
                Padding(
                  padding: const EdgeInsets.only(top: 80),
                  child: Center(
                    child: Text('New  Winter  2025',
                    style: GoogleFonts.aboreto(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(255, 33, 12, 4),
                    ),),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 130),
                  child: Center(
                      child: Text('Collections.',
                      style: GoogleFonts.aboreto(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(255, 33, 12, 4),
                      ),),
                    ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 190),
                  child: Center(
                    child: Container(
                      width: 150,
                      height: 50,
                         decoration: BoxDecoration(
                           borderRadius: BorderRadius.circular(8.0),
                           border: Border.all(color:const Color.fromARGB(255, 36, 14, 5),)
                         ),
                           child: Center(
                             child: Text('Shop Now',
                                 style: GoogleFonts.aBeeZee(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: const Color.fromARGB(255, 36, 14, 5),
                               ),),
                           ), 
                   ),
                   ),
                  ),
                   ],
             ),
               Row(
                 children: [
                   Padding(
                     padding: const EdgeInsets.only(top: 10,left: 15),
                     child: Text(
                       'Selling fast 🔥',
                        style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      ),
                      ),
                   ),
                Padding(
                  padding: const EdgeInsets.only(top: 10,left: 280),
                  child: Row(
                      children: [
                        Icon(Icons.favorite, color: Colors.red),
                        Text('14'),
                        SizedBox(width: 10),
                        Icon(Icons.shopping_cart_outlined),
                      ],
                    ),
                ),
                  ],
               ),
            SizedBox(height: 8),
            SizedBox(
              height: 180,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children:  [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Product(
                      imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRUCNS5650XQ1jlnfKTZev1qZC8y6jbj-bc0jXsYN2pTTEH3cwwAfw0ahll6wGOrXaLgAA&usqp=CAU',
                      name: 'Basic High Dyair',
                      price: '\$29.90',
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Product(
                      imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQio525Qfmd_FdUPlaGnC5XBMRSq9cCYpZU4arRRX5uqlKW_MKh-_mZeDfFvjhEw1mVbxc&usqp=CAU',
                      name: 'Long Faux Shearling',
                      price: '\$49.00',
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Product(
                      imageUrl: 'https://fas-bee.com/cdn/shop/files/MG6870EU000001_021.jpg?v=1741702128&width=1500',
                      name: 'Street Casual',
                      price: '\$39.50',
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Product(
                      imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTWUigZc3Prd2ct8pbThEkGU7j6S9NebGOQiyoYkkUIG7zOAIOxUJVPCT1ahXiVH2qxDW0&usqp=CAU',
                      name: 'Sherpa Jacket',
                      price: '\$32.50',
                    ),
                  ),Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Product(
                      imageUrl: 'https://fas-bee.com/cdn/shop/files/MG6870EU000001_021.jpg?v=1741702128&width=1500',
                      name: 'Street Casual',
                      price: '\$30.50',
                    ),
                  ),Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Product(
                      imageUrl: 'https://img.drz.lazcdn.com/static/bd/p/1406b04413e5b04fa1fd3d5fffa35b39.jpg_720x720q80.jpg',
                      name: "Women's Jacket",
                      price: '\$29.50',
                    ),
                  ),Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Product(
                      imageUrl: 'https://negativeapparel.com/cdn/shop/files/mid-length-thick-woolen-coat-for-women-negative-apparel-741660.jpg?v=1727907831&width=800',
                      name: 'Long Coats',
                      price: '\$49.50',
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10,right: 335),
              child: Text(
                'Popular products',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
             SizedBox(height: 20),
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
             // childAspectRatio: 1/2,
             // mainAxisSpacing: 5,
             // crossAxisSpacing: 5,
             // physics: const NeverScrollableScrollPhysics(),
              children: [
                ProductCard(
                  imageUrl: 'https://i.ytimg.com/vi/BwzSKVUUs4U/hq720.jpg?sqp=-oaymwE7CK4FEIIDSFryq4qpAy0IARUAAAAAGAElAADIQj0AgKJD8AEB-AHOBYAChAeKAgwIABABGGUgZShNMA8=&rs=AOn4CLAUhnNXoRJAyodPaRRVTNQI-VywHg',
                  name: 'Sweater',
                  price: '\$20.00',
                ),
                ProductCard(
                  imageUrl: 'https://m.media-amazon.com/images/I/71zwwEe2nLL._AC_SL1500_.jpg',
                  name: 'Jacket',
                  price: '\$35.00',
                ),
                ProductCard(
                  imageUrl: 'https://images.printify.com/api/catalog/66d852f87e0e8a02890d46e2?s=320',
                  name: 'Hoodies',
                  price: '\$32.00',
                ),
                ProductCard(
                  imageUrl: 'https://negativeapparel.com/cdn/shop/files/mid-length-thick-woolen-coat-for-women-negative-apparel-741660.jpg?v=1727907831&width=800',
                  name: 'Coats',
                  price: '\$35.00',
                ),
           ],
           ),
          ]
      ),
      ),
       /* bottomNavigationBar: StylishBottomBar(
        items:  [
        BottomBarItem(
        icon: Icon(Icons.home_outlined,color: Colors.brown,), 
        title: Text('Home',style: TextStyle(color: Colors.brown,),)),
        BottomBarItem(
        icon: Icon(Icons.search,color: Colors.brown,), 
        title: Text('Search',style: TextStyle(color: Colors.brown,),)),
        BottomBarItem(
        icon: Icon(Icons.shopping_bag_outlined,color: Colors.brown,), 
        title: Text('Bag',style: TextStyle(color: Colors.brown,),)),
        BottomBarItem(
        icon: Icon(Icons.person_outline_outlined,color: Colors.brown,), 
        title: Text('Profile',style: TextStyle(color: Colors.brown,),)),
        
      ], 
    option: AnimatedBarOptions(
    iconSize: 32,
    barAnimation: BarAnimation.fade,
    iconStyle: IconStyle.animated,
    //opacity: 0.3,
 ),
        hasNotch: true,
        currentIndex: selectedindex,
        onTap: (index) {
          setState(() {
            selectedindex = index;
          }
          );
  }
  ),
       */
      );
  }
}
class ProductCard extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String price;

  const ProductCard({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 180,
          width: 180,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            image: DecorationImage(
              image: NetworkImage(imageUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
         SizedBox(height: 8),
        Text(
          name,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Text(
          price,
          style: const TextStyle(fontSize: 14, color: Colors.brown),
        ),
      ],
    );
  }
}


class Product extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String price;

  const Product({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      //crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 120,
          width: 120,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            image: DecorationImage(
              image: NetworkImage(imageUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
         SizedBox(height: 8),
        Text(
          name,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Text(
          price,
          style: const TextStyle(fontSize: 14, color: Colors.brown),
        ),
      ],
    );
  }
}  */