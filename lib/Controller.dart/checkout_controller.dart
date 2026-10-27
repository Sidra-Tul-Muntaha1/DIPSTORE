import 'package:DIPSTORE/Model.dart/cart_item.dart';
import 'package:DIPSTORE/Model.dart/order_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

/// Firestore collection path: users/{uid}/orders/{orderId}
const String _ordersCollection = 'orders';
const String _usersCollection = 'users';

/// Result returned from a checkout submission attempt.
class CheckoutResult {
  final bool success;
  final String? orderId;
  final String? errorMessage;
  final OrderModel? order;

  const CheckoutResult.success({required this.orderId, required this.order})
      : success = true,
        errorMessage = null;

  const CheckoutResult.failure({required this.errorMessage})
      : success = false,
        orderId = null,
        order = null;
}

class CheckoutController extends GetxController {
  final isSubmitting = false.obs;
  final lastError = ''.obs;

  FirebaseFirestore get _firestore => FirebaseFirestore.instance;
  FirebaseAuth get _auth => FirebaseAuth.instance;

  /// The currently signed-in user, or null if guest.
  User? get currentUser => _auth.currentUser;
  bool get isSignedIn => currentUser != null;

  /// Build the order path for the current user.
  CollectionReference _userOrdersRef(String uid) =>
      _firestore.collection(_usersCollection).doc(uid).collection(_ordersCollection);

  /// Submits a COD order to Firestore.
  ///
  /// Returns [CheckoutResult.success] only when the Firestore write succeeds.
  /// Returns [CheckoutResult.failure] on any error, preserving the cart.
  Future<CheckoutResult> submitCodOrder({
    required String customerName,
    required String phoneNumber,
    required String city,
    required String deliveryAddress,
    String? deliveryInstructions,
    required List<CartItem> cartItems,
    required double subtotal,
  }) async {
    // Guard: must be signed in
    final user = currentUser;
    if (user == null) {
      return const CheckoutResult.failure(
        errorMessage: 'You must be signed in to place an order.',
      );
    }

    // Guard: prevent duplicate submission
    if (isSubmitting.value) {
      return const CheckoutResult.failure(
        errorMessage: 'Order submission is already in progress.',
      );
    }

    // Guard: cart must not be empty
    if (cartItems.isEmpty) {
      return const CheckoutResult.failure(
        errorMessage: 'Your cart is empty. Add items before checking out.',
      );
    }

    isSubmitting.value = true;
    lastError.value = '';

    try {
      final deliveryFee = DeliveryFeePolicy.calculateFee(subtotal);
      final total = subtotal + deliveryFee;

      // Build immutable order item snapshots
      final orderItems = cartItems.map((item) {
        return OrderItem(
          productId: item.id,
          title: item.title,
          brand: item.brand,
          imageUrl: item.imageUrl,
          category: item.category,
          size: item.size,
          unitPrice: item.unitPrice,
          quantity: item.quantity,
          lineTotal: item.lineTotal,
        );
      }).toList();

      final orderModel = OrderModel(
        userId: user.uid,
        customerName: customerName.trim(),
        phoneNumber: phoneNumber.trim(),
        city: city.trim(),
        deliveryAddress: deliveryAddress.trim(),
        deliveryInstructions: deliveryInstructions?.trim().isNotEmpty == true
            ? deliveryInstructions!.trim()
            : null,
        items: orderItems,
        subtotal: subtotal,
        deliveryFee: deliveryFee,
        total: total,
        currency: DeliveryFeePolicy.currency,
        paymentMethod: PaymentMethod.cashOnDelivery,
        paymentStatus: 'PENDING',
        orderStatus: 'PLACED',
      );

      // Write to Firestore — only report success after confirmed write
      final docRef = await _userOrdersRef(user.uid).add(orderModel.toFirestore());

      // Create ORDER_PLACED in-app notification in users/{uid}/notifications
      try {
        final orderShortId = docRef.id.length >= 8
            ? docRef.id.substring(0, 8).toUpperCase()
            : docRef.id.toUpperCase();
        await _firestore
            .collection(_usersCollection)
            .doc(user.uid)
            .collection('notifications')
            .add({
          'title': 'Order Placed Successfully',
          'message':
              'Your order #$orderShortId has been confirmed for \$${total.toStringAsFixed(2)} via Cash on Delivery.',
          'type': 'ORDER_PLACED',
          'orderId': docRef.id,
          'isRead': false,
          'createdAt': FieldValue.serverTimestamp(),
        });
      } catch (notifErr) {
        // Notification write failure must not fail the confirmed order or undo success
        debugPrint('Checkout notification write error: $notifErr');
      }

      return CheckoutResult.success(
        orderId: docRef.id,
        order: OrderModel(
          orderId: docRef.id,
          userId: orderModel.userId,
          customerName: orderModel.customerName,
          phoneNumber: orderModel.phoneNumber,
          city: orderModel.city,
          deliveryAddress: orderModel.deliveryAddress,
          deliveryInstructions: orderModel.deliveryInstructions,
          items: orderModel.items,
          subtotal: orderModel.subtotal,
          deliveryFee: orderModel.deliveryFee,
          total: orderModel.total,
          currency: orderModel.currency,
          paymentMethod: orderModel.paymentMethod,
          paymentStatus: orderModel.paymentStatus,
          orderStatus: orderModel.orderStatus,
          placedAt: DateTime.now(),
        ),
      );
    } on FirebaseException catch (e) {
      final msg = _firestoreErrorMessage(e);
      lastError.value = msg;
      return CheckoutResult.failure(errorMessage: msg);
    } catch (e) {
      final msg = 'Unexpected error: ${e.toString()}';
      lastError.value = msg;
      return CheckoutResult.failure(errorMessage: msg);
    } finally {
      isSubmitting.value = false;
    }
  }

  /// Maps FirebaseException codes to human-readable messages.
  String _firestoreErrorMessage(FirebaseException e) {
    switch (e.code) {
      case 'permission-denied':
        return 'Permission denied. Please sign in and try again.';
      case 'unavailable':
        return 'Service temporarily unavailable. Please check your connection and retry.';
      case 'unauthenticated':
        return 'Your session has expired. Please sign in again.';
      case 'deadline-exceeded':
        return 'Request timed out. Please try again.';
      default:
        return 'Order could not be placed (${e.code}). Please retry.';
    }
  }
}
