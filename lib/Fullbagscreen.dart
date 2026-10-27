import 'package:DIPSTORE/Controller.dart/cart_controller.dart';
import 'package:DIPSTORE/Emptybagscreen.dart';
import 'package:DIPSTORE/Widgets.dart/fashion_image.dart';
import 'package:DIPSTORE/checkout_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class FullBagScreen extends StatefulWidget {
  final VoidCallback? onStartShopping;
  const FullBagScreen({super.key, this.onStartShopping});

  @override
  State<FullBagScreen> createState() => _FullBagScreenState();
}

class _FullBagScreenState extends State<FullBagScreen> {
  @override
  Widget build(BuildContext context) {
    final CartController cartController = Get.isRegistered<CartController>()
        ? Get.find<CartController>()
        : Get.put(CartController());

    return Obx(() {
      if (cartController.isEmpty) {
        return EmptyBagScreen(onStartShopping: widget.onStartShopping);
      }

      final items = cartController.cartItems;

      return Scaffold(
        backgroundColor: const Color(0xFFFEEFE3),
        appBar: AppBar(
          title: Text(
            "Shopping Bag (${cartController.totalItemCount})",
            style: GoogleFonts.aBeeZee(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          actions: [
            if (cartController.isNotEmpty)
              IconButton(
                icon: const Icon(Icons.delete_sweep_outlined, color: Colors.brown),
                tooltip: 'Clear Cart',
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Clear Shopping Bag?'),
                      content: const Text(
                        'Are you sure you want to remove all items from your bag?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            cartController.clearCart();
                            Navigator.pop(ctx);
                          },
                          child: const Text(
                            'Clear',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            const SizedBox(width: 8),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                itemCount: items.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final item = items[index];

                  return Container(
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
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 10,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Checkbox(
                          value: item.selected,
                          activeColor: Colors.brown,
                          onChanged: (val) {
                            cartController.toggleItemSelected(
                              item,
                              val ?? false,
                            );
                          },
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: FashionImage(
                            imageUrl: item.imageUrl,
                            height: 70,
                            width: 70,
                            fit: BoxFit.cover,
                            placeholderLabel: item.brand,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.brand.toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                  letterSpacing: 1.0,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                item.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                "Size: ${item.size}",
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Text(
                                    "\$${item.unitPrice.toStringAsFixed(2)}",
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  if (item.quantity > 1) ...[
                                    const SizedBox(width: 8),
                                    Text(
                                      "Total: \$${item.lineTotal.toStringAsFixed(2)}",
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.brown,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            IconButton(
                              visualDensity: VisualDensity.compact,
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              icon: const Icon(
                                Icons.delete_outline,
                                color: Colors.redAccent,
                                size: 20,
                              ),
                              onPressed: () {
                                cartController.removeFromCart(item);
                              },
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  visualDensity: VisualDensity.compact,
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                  icon: Icon(
                                    Icons.remove_circle_outline,
                                    size: 22,
                                    color: item.quantity > 1
                                        ? Colors.brown
                                        : Colors.grey[400],
                                  ),
                                  onPressed: item.quantity > 1
                                      ? () => cartController.decrementQuantity(item)
                                      : null,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                  ),
                                  child: Text(
                                    '${item.quantity}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  visualDensity: VisualDensity.compact,
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                  icon: const Icon(
                                    Icons.add_circle_outline,
                                    size: 22,
                                    color: Colors.brown,
                                  ),
                                  onPressed: () =>
                                      cartController.incrementQuantity(item),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    offset: const Offset(0, -2),
                    blurRadius: 6,
                  ),
                ],
              ),
              child: SafeArea(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Checkbox(
                          value: cartController.isAllSelected,
                          activeColor: Colors.brown,
                          onChanged: (val) {
                            cartController.toggleSelectAll(val ?? false);
                          },
                        ),
                        Text(
                          "Choose all (${cartController.totalItemCount})",
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        const Spacer(),
                        const Text(
                          "Subtotal: ",
                          style: TextStyle(color: Colors.grey, fontSize: 13),
                        ),
                        Text(
                          "\$${cartController.subtotal.toStringAsFixed(2)}",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 36, 14, 5),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: cartController.subtotal > 0
                          ? () {
                              // Pass only selected items to checkout
                              final selectedItems = cartController.cartItems
                                  .where((item) => item.selected)
                                  .toList();
                              if (selectedItems.isEmpty) return;
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => CheckoutScreen(
                                    selectedItems: selectedItems,
                                    subtotal: cartController.subtotal,
                                    onOrderPlaced: widget.onStartShopping,
                                  ),
                                ),
                              );
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 36, 14, 5),
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        cartController.selectedItemCount > 0
                            ? "Checkout (${cartController.selectedItemCount} items)"
                            : "Select items to Checkout",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
