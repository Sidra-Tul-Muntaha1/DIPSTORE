import 'package:DIPSTORE/BottomNavBar.dart';
import 'package:DIPSTORE/Model.dart/order_model.dart';
import 'package:DIPSTORE/Widgets.dart/fashion_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

/// Shown after a successful order submission.
class OrderConfirmationScreen extends StatelessWidget {
  final OrderModel order;
  final VoidCallback? onContinueShopping;

  const OrderConfirmationScreen({
    super.key,
    required this.order,
    this.onContinueShopping,
  });

  void _returnToHome(BuildContext context) {
    if (onContinueShopping != null) {
      try {
        onContinueShopping!();
        return;
      } catch (_) {}
    }
    // Cleanly clear checkout/confirmation routes and return to Bottomnavbar on Home (index 0)
    Get.offAll(() => const Bottomnavbar(initialIndex: 0));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // Prevent back navigation to checkout screen; return to Home instead
      onWillPop: () async {
        _returnToHome(context);
        return false;
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFFEEFE3),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Text(
            'Order Confirmed!',
            style: GoogleFonts.aBeeZee(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Success banner
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 36, 14, 5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    const Icon(
                      Icons.check_circle_outline,
                      color: Color(0xFFFEEFE3),
                      size: 56,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Thank you, ${order.customerName.split(' ').first}!',
                      style: GoogleFonts.aBeeZee(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Your order has been placed successfully.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'Order Reference',
                            style: TextStyle(color: Colors.white60, fontSize: 12),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            order.orderId ?? '—',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Delivery details card
              _SectionCard(
                title: 'Delivery Details',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _DetailRow(label: 'Name', value: order.customerName),
                    _DetailRow(label: 'Phone', value: order.phoneNumber),
                    _DetailRow(label: 'City', value: order.city),
                    _DetailRow(label: 'Address', value: order.deliveryAddress),
                    if (order.deliveryInstructions != null &&
                        order.deliveryInstructions!.isNotEmpty)
                      _DetailRow(
                        label: 'Instructions',
                        value: order.deliveryInstructions!,
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // Order items card
              _SectionCard(
                title: 'Order Items (${order.items.length})',
                child: Column(
                  children: order.items.map((item) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: FashionImage(
                              imageUrl: item.imageUrl,
                              height: 50,
                              width: 50,
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
                                    fontSize: 10,
                                    color: Colors.grey,
                                    letterSpacing: 1,
                                  ),
                                ),
                                Text(
                                  item.title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                                Text(
                                  'Qty: ${item.quantity} × \$${item.unitPrice.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            '\$${item.lineTotal.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 12),

              // Payment summary card
              _SectionCard(
                title: 'Payment Summary',
                child: Column(
                  children: [
                    _TotalRow(label: 'Subtotal', value: order.subtotal),
                    _TotalRow(
                      label: 'Delivery fee',
                      value: order.deliveryFee,
                      note: '(placeholder — flat rate)',
                    ),
                    const Divider(height: 16),
                    _TotalRow(
                      label: 'Total',
                      value: order.total,
                      bold: true,
                      fontSize: 16,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Payment',
                          style: TextStyle(color: Colors.grey, fontSize: 13),
                        ),
                        Text(
                          order.paymentMethod.displayName,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Payment status',
                          style: TextStyle(color: Colors.grey, fontSize: 13),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.orange.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            order.paymentStatus,
                            style: const TextStyle(
                              color: Colors.orange,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 36, 14, 5),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () => _returnToHome(context),
                child: const Text(
                  'Continue Shopping',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Helper widgets ───────────────────────────────────────────────────────────

class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;

  const _SectionCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 90,
            child: Text(
              '$label:',
              style: const TextStyle(color: Colors.grey, fontSize: 13),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}

class _TotalRow extends StatelessWidget {
  final String label;
  final double value;
  final bool bold;
  final double fontSize;
  final String? note;

  const _TotalRow({
    required this.label,
    required this.value,
    this.bold = false,
    this.fontSize = 14,
    this.note,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              note != null ? '$label $note' : label,
              style: TextStyle(
                fontSize: note != null ? 12 : fontSize,
                fontWeight: bold ? FontWeight.bold : FontWeight.normal,
                color: note != null ? Colors.grey : null,
              ),
            ),
          ),
          Text(
            '\$${value.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: bold ? FontWeight.bold : FontWeight.w600,
              color: bold ? const Color.fromARGB(255, 36, 14, 5) : Colors.green,
            ),
          ),
        ],
      ),
    );
  }
}
