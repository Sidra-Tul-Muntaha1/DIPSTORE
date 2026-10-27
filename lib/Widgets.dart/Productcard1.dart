
import 'package:DIPSTORE/Controller.dart/favourite_controller.dart';
import 'package:DIPSTORE/Model.dart/Productmodel.dart';
import 'package:DIPSTORE/Productdetailscreen.dart';
import 'package:DIPSTORE/Widgets.dart/fashion_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductCard1 extends StatefulWidget {
  final Product product;

  const ProductCard1({super.key, required this.product});

  @override
  State<ProductCard1> createState() => _ProductCard1State();
}

class _ProductCard1State extends State<ProductCard1> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ProductDetailScreen(product: widget.product),
        ),
      ),
      child: Container(
        width: 140,
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                  child: FashionImage(
                    imageUrl: widget.product.image,
                    height: 160,
                    width: 140,
                    fit: BoxFit.cover,
                    placeholderLabel: widget.product.brand,
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Builder(builder: (context) {
                    final favController = Get.isRegistered<FavouriteController>()
                        ? Get.find<FavouriteController>()
                        : Get.put(FavouriteController());
                    return Obx(() {
                      final isFav = favController.isFavourite(widget.product);
                      return GestureDetector(
                        onTap: () => favController.toggleFavourite(widget.product),
                        child: CircleAvatar(
                          radius: 12,
                          backgroundColor: Colors.white.withOpacity(0.9),
                          child: Icon(
                            isFav ? Icons.favorite : Icons.favorite_border,
                            size: 14,
                            color: isFav ? Colors.red : Colors.grey,
                          ),
                        ),
                      );
                    });
                  }),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                widget.product.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    if (widget.product.oldPrice != null)
                      Text(
                        widget.product.oldPrice!,
                        style: const TextStyle(
                          decoration: TextDecoration.lineThrough,
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    const SizedBox(width: 4),
                    Text(
                      widget.product.price,
                      style: const TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
