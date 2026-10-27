
import 'package:DIPSTORE/Controller.dart/favourite_controller.dart';
import 'package:DIPSTORE/Controller.dart/product_controller.dart';
import 'package:DIPSTORE/Model.dart/Productmodel.dart';
import 'package:DIPSTORE/Productdetailscreen.dart';
import 'package:DIPSTORE/Widgets.dart/fashion_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class BrandPage extends StatelessWidget {
  final String brandName;

  const BrandPage({
    super.key,
    required this.brandName,
  });

  @override
  Widget build(BuildContext context) {
    final ProductController productController = Get.isRegistered<ProductController>()
        ? Get.find<ProductController>()
        : Get.put(ProductController());

    return Scaffold(
      backgroundColor: const Color(0xFFFEEFE3),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          brandName,
          style: GoogleFonts.aBeeZee(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        final brandProducts = productController.getProductsByBrand(brandName);

        if (productController.isLoading.value && brandProducts.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.brown),
          );
        }

        if (brandProducts.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.checkroom_outlined,
                    size: 64,
                    color: Colors.brown,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No items found for $brandName',
                    style: GoogleFonts.aBeeZee(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Check back soon for new arrivals from this brand.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.brown,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Back to Catalog'),
                  ),
                ],
              ),
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '$brandName Collection',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${brandProducts.length} items',
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.brown,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.72,
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 14,
                ),
                itemCount: brandProducts.length,
                itemBuilder: (context, index) {
                  final product = brandProducts[index];
                  return BrandProductCard(product: product);
                },
              ),
            ),
          ],
        );
      }),
    );
  }
}

class BrandProductCard extends StatelessWidget {
  final Product product;

  const BrandProductCard({
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
                    placeholderLabel: product.brand ?? 'DIPSTORE',
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
