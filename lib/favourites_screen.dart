
import 'package:DIPSTORE/Controller.dart/cart_controller.dart';
import 'package:DIPSTORE/Controller.dart/favourite_controller.dart';
import 'package:DIPSTORE/Productdetailscreen.dart';
import 'package:DIPSTORE/Widgets.dart/fashion_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class FavouritesScreen extends StatelessWidget {
  final VoidCallback? onStartShopping;

  const FavouritesScreen({super.key, this.onStartShopping});

  @override
  Widget build(BuildContext context) {
    final FavouriteController favController =
        Get.isRegistered<FavouriteController>()
            ? Get.find<FavouriteController>()
            : Get.put(FavouriteController());

    final CartController cartController = Get.isRegistered<CartController>()
        ? Get.find<CartController>()
        : Get.put(CartController());

    return Scaffold(
      backgroundColor: const Color(0xFFFEEFE3),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: BackButton(
  onPressed: () {
     Get.back();
  },
),
        title: Obx(() => Text(
              'My Wishlist (${favController.count})',
              style: GoogleFonts.aBeeZee(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            )),
        centerTitle: true,
      ),
      body: Obx(() {
        if (favController.favourites.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.favorite_border,
                      size: 40,
                      color: Colors.brown,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Your Wishlist is Empty',
                    style: GoogleFonts.aBeeZee(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(255, 36, 14, 5),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Explore our fashion catalog and tap the heart icon on items you love.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 36, 14, 5),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 28,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      if (onStartShopping != null) {
                        onStartShopping!();
                      } else {
                        Navigator.pop(context);
                      }
                    },
                    child: const Text(
                      'Start Shopping',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        final items = favController.favourites;

        return GridView.builder(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 95),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.65,
            mainAxisSpacing: 14,
            crossAxisSpacing: 14,
          ),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final product = items[index];

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
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image with active heart badge
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
                            child: GestureDetector(
                              onTap: () => favController.toggleFavourite(product),
                              child: const CircleAvatar(
                                radius: 14,
                                backgroundColor: Colors.white,
                                child: Icon(
                                  Icons.favorite,
                                  size: 16,
                                  color: Colors.red,
                                ),
                              ),
                            ),
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
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            product.brand ?? 'DIPSTORE',
                            style: const TextStyle(
                              fontSize: 11,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                product.price,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  cartController.addToCart(product);
                                  Get.snackbar(
                                    'Added to Bag',
                                    '${product.title} added to your shopping bag.',
                                    snackPosition: SnackPosition.BOTTOM,
                                    duration: const Duration(seconds: 2),
                                    backgroundColor: Colors.white,
                                    colorText:
                                        const Color.fromARGB(255, 36, 14, 5),
                                    margin: const EdgeInsets.all(12),
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(255, 36, 14, 5),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: const Icon(
                                    Icons.shopping_bag_outlined,
                                    size: 14,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
