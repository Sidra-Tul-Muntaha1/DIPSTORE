
import 'package:DIPSTORE/BottomNavBar.dart';
import 'package:DIPSTORE/Controller.dart/cart_controller.dart';
import 'package:DIPSTORE/Controller.dart/checkout_controller.dart';
import 'package:DIPSTORE/Model.dart/cart_item.dart';
import 'package:DIPSTORE/Model.dart/order_model.dart';
import 'package:DIPSTORE/Widgets.dart/fashion_image.dart';
import 'package:DIPSTORE/order_confirmation_screen.dart';
import 'package:DIPSTORE/signin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class CheckoutScreen extends StatefulWidget {
  /// Items being checked out. These are the *selected* items from the cart.
  final List<CartItem> selectedItems;
  final double subtotal;
  final VoidCallback? onOrderPlaced; // Navigate home or refresh

  const CheckoutScreen({
    super.key,
    required this.selectedItems,
    required this.subtotal,
    this.onOrderPlaced,
  });

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _cityController = TextEditingController();
  final _addressController = TextEditingController();
  final _instructionsController = TextEditingController();

  PaymentMethod _selectedPayment = PaymentMethod.cashOnDelivery;

  late final CheckoutController _checkoutController;
  late final CartController _cartController;

  double get _deliveryFee => DeliveryFeePolicy.calculateFee(widget.subtotal);
  double get _total => widget.subtotal + _deliveryFee;

  @override
  void initState() {
    super.initState();
    _checkoutController = Get.isRegistered<CheckoutController>()
        ? Get.find<CheckoutController>()
        : Get.put(CheckoutController());
    _cartController = Get.isRegistered<CartController>()
        ? Get.find<CartController>()
        : Get.put(CartController());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _cityController.dispose();
    _addressController.dispose();
    _instructionsController.dispose();
    super.dispose();
  }

  // ── Field Validators ────────────────────────────────────────────────────────

  String? _validateName(String? v) {
    if (v == null || v.trim().isEmpty) return 'Full name is required';
    if (v.trim().length < 2) return 'Enter a valid full name';
    return null;
  }

  String? _validatePhone(String? v) {
    if (v == null || v.trim().isEmpty) return 'Phone number is required';
    final digits = v.replaceAll(RegExp(r'\D'), '');
    if (digits.length < 7 || digits.length > 15) {
      return 'Enter a valid phone number';
    }
    return null;
  }

  String? _validateCity(String? v) {
    if (v == null || v.trim().isEmpty) return 'City is required';
    return null;
  }

  String? _validateAddress(String? v) {
    if (v == null || v.trim().isEmpty) return 'Delivery address is required';
    if (v.trim().length < 10) return 'Please enter a complete address';
    return null;
  }

  // ── Submit ──────────────────────────────────────────────────────────────────

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    // Guest guard
    if (!_checkoutController.isSignedIn) {
      _showSignInRequired();
      return;
    }

    // Prevent double-submit
    if (_checkoutController.isSubmitting.value) return;

    // Online payment guard — no provider configured
    if (_selectedPayment == PaymentMethod.onlinePayment) {
      _showOnlinePaymentUnavailable();
      return;
    }

    final result = await _checkoutController.submitCodOrder(
      customerName: _nameController.text,
      phoneNumber: _phoneController.text,
      city: _cityController.text,
      deliveryAddress: _addressController.text,
      deliveryInstructions: _instructionsController.text,
      cartItems: widget.selectedItems,
      subtotal: widget.subtotal,
    );

    if (!mounted) return;

    if (result.success && result.order != null) {
      // Clear only the purchased (selected) items from the cart
      for (final item in widget.selectedItems) {
        _cartController.cartItems.remove(item);
      }
      _cartController.cartItems.refresh();

      // Navigate to confirmation screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => OrderConfirmationScreen(
            order: result.order!,
            onContinueShopping: () {
              Get.offAll(() => const Bottomnavbar(initialIndex: 0));
              if (widget.onOrderPlaced != null) widget.onOrderPlaced!();
            },
          ),
        ),
      );
    } else {
      // Show error — cart and form data are preserved
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            result.errorMessage ?? 'Order could not be placed. Please try again.',
          ),
          backgroundColor: Colors.red[700],
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 4),
        ),
      );
    }
  }

  void _showSignInRequired() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Sign In Required'),
        content: const Text(
          'Please sign in to place your order. Your cart will be saved.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 36, 14, 5),
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const Signin()),
              );
            },
            child: const Text('Sign In'),
          ),
        ],
      ),
    );
  }

  void _showOnlinePaymentUnavailable() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Online Payment Unavailable'),
        content: const Text(
          'Online payment is not yet configured for DIPSTORE.\n\n'
          'To enable it, the following will be required:\n'
          '• A merchant account with a payment provider (e.g. Stripe, Razorpay)\n'
          '• Provider SDK integration and API keys (server-side only)\n'
          '• A backend endpoint to create and verify payment intents\n'
          '• Webhook handling to update order status after payment confirmation\n\n'
          'Please select Cash on Delivery to place your order now.',
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 36, 14, 5),
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(ctx);
              setState(() {
                _selectedPayment = PaymentMethod.cashOnDelivery;
              });
            },
            child: const Text('Use Cash on Delivery'),
          ),
        ],
      ),
    );
  }

  // ── Build ────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
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
          'Checkout',
          style: GoogleFonts.aBeeZee(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        final submitting = _checkoutController.isSubmitting.value;
        return Stack(
          children: [
            Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Delivery Information ──
                    _SectionHeader('Delivery Information'),
                    const SizedBox(height: 10),
                    _buildTextField(
                      controller: _nameController,
                      label: 'Full Name',
                      hint: 'e.g. Aisha Khan',
                      icon: Icons.person_outline,
                      validator: _validateName,
                      enabled: !submitting,
                      textCapitalization: TextCapitalization.words,
                    ),
                    const SizedBox(height: 12),
                    _buildTextField(
                      controller: _phoneController,
                      label: 'Phone Number',
                      hint: 'e.g. +92 300 1234567',
                      icon: Icons.phone_outlined,
                      validator: _validatePhone,
                      enabled: !submitting,
                      keyboardType: TextInputType.phone,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9+\- ]')),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildTextField(
                      controller: _cityController,
                      label: 'City',
                      hint: 'e.g. Lahore',
                      icon: Icons.location_city_outlined,
                      validator: _validateCity,
                      enabled: !submitting,
                      textCapitalization: TextCapitalization.words,
                    ),
                    const SizedBox(height: 12),
                    _buildTextField(
                      controller: _addressController,
                      label: 'Full Delivery Address',
                      hint: 'House no., street, area, landmark...',
                      icon: Icons.home_outlined,
                      validator: _validateAddress,
                      enabled: !submitting,
                      maxLines: 3,
                      textCapitalization: TextCapitalization.sentences,
                    ),
                    const SizedBox(height: 12),
                    _buildTextField(
                      controller: _instructionsController,
                      label: 'Delivery Instructions (optional)',
                      hint: 'e.g. Call before arriving, ring doorbell twice',
                      icon: Icons.notes_outlined,
                      enabled: !submitting,
                      maxLines: 2,
                      textCapitalization: TextCapitalization.sentences,
                    ),

                    const SizedBox(height: 20),

                    // ── Order Summary ──
                    _SectionHeader(
                      'Order Summary (${widget.selectedItems.length} items)',
                    ),
                    const SizedBox(height: 10),
                    _OrderSummaryCard(
                      items: widget.selectedItems,
                      subtotal: widget.subtotal,
                      deliveryFee: _deliveryFee,
                      total: _total,
                    ),

                    const SizedBox(height: 20),

                    // ── Payment Method ──
                    _SectionHeader('Payment Method'),
                    const SizedBox(height: 10),
                    _PaymentSelector(
                      selected: _selectedPayment,
                      enabled: !submitting,
                      onChanged: (method) {
                        setState(() => _selectedPayment = method);
                      },
                    ),

                    const SizedBox(height: 28),

                    // ── Place Order button ──
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 36, 14, 5),
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 52),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 0,
                      ),
                      onPressed: submitting ? null : _submit,
                      child: Text(
                        submitting
                            ? 'Placing order…'
                            : 'Place Order · \$${_total.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Security note
                    const Center(
                      child: Text(
                        '🔒 Your order details are securely saved',
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            // Full-screen loading overlay while submitting
            if (submitting)
              Container(
                color: Colors.black.withOpacity(0.25),
                child: const Center(
                  child: Card(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProgressIndicator(color: Colors.brown),
                          SizedBox(height: 16),
                          Text('Placing your order…'),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );
      }),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    String? Function(String?)? validator,
    bool enabled = true,
    int maxLines = 1,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    TextCapitalization textCapitalization = TextCapitalization.none,
  }) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      maxLines: maxLines,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      textCapitalization: textCapitalization,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        hintStyle: const TextStyle(fontSize: 13, color: Colors.grey),
        prefixIcon: Icon(icon, color: Colors.brown, size: 20),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Color.fromARGB(255, 215, 183, 171),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Color.fromARGB(255, 36, 14, 5),
            width: 1.5,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),
      ),
    );
  }
}

// ─── Helper widgets ───────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader(this.title);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Color.fromARGB(255, 36, 14, 5),
      ),
    );
  }
}

class _OrderSummaryCard extends StatelessWidget {
  final List<CartItem> items;
  final double subtotal;
  final double deliveryFee;
  final double total;

  const _OrderSummaryCard({
    required this.items,
    required this.subtotal,
    required this.deliveryFee,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color.fromARGB(255, 215, 183, 171),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          ...items.map((item) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: FashionImage(
                        imageUrl: item.imageUrl,
                        height: 44,
                        width: 44,
                        fit: BoxFit.cover,
                        placeholderLabel: item.brand,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            '${item.brand} · Qty ${item.quantity}',
                            style: const TextStyle(
                              fontSize: 11,
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
                        fontSize: 13,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              )),
          const Divider(height: 16),
          _Row(label: 'Subtotal', value: '\$${subtotal.toStringAsFixed(2)}'),
          // Clearly labelled placeholder delivery fee
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Flexible(
                  child: Text(
                    'Delivery fee (flat placeholder)',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ),
                Text(
                  '\$${deliveryFee.toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 12),
          _Row(
            label: 'Total',
            value: '\$${total.toStringAsFixed(2)}',
            bold: true,
          ),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final String label;
  final String value;
  final bool bold;

  const _Row({required this.label, required this.value, this.bold = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
              fontSize: bold ? 15 : 13,
              color: bold ? const Color.fromARGB(255, 36, 14, 5) : Colors.grey,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: bold ? FontWeight.bold : FontWeight.w600,
              fontSize: bold ? 16 : 13,
              color: bold ? const Color.fromARGB(255, 36, 14, 5) : null,
            ),
          ),
        ],
      ),
    );
  }
}

class _PaymentSelector extends StatelessWidget {
  final PaymentMethod selected;
  final bool enabled;
  final void Function(PaymentMethod) onChanged;

  const _PaymentSelector({
    required this.selected,
    required this.enabled,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color.fromARGB(255, 215, 183, 171),
          width: 1,
        ),
      ),
      child: Column(
        children: PaymentMethod.values.map((method) {
          final isSelected = selected == method;
          final isCod = method == PaymentMethod.cashOnDelivery;

          return RadioListTile<PaymentMethod>(
            value: method,
            groupValue: selected,
            onChanged: enabled ? (val) => onChanged(val!) : null,
            activeColor: const Color.fromARGB(255, 36, 14, 5),
            title: Row(
              children: [
                Icon(
                  isCod ? Icons.money : Icons.credit_card_outlined,
                  size: 18,
                  color: isSelected
                      ? const Color.fromARGB(255, 36, 14, 5)
                      : Colors.grey,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    method.displayName,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isCod
                          ? const Color.fromARGB(255, 36, 14, 5)
                          : Colors.grey,
                    ),
                  ),
                ),
                if (!isCod)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'COMING SOON',
                      style: TextStyle(
                        fontSize: 9,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            subtitle: isCod
                ? const Text(
                    'Pay when your order is delivered',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  )
                : const Text(
                    'Requires payment provider setup',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
          );
        }).toList(),
      ),
    );
  }
}
