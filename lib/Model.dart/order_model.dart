import 'package:cloud_firestore/cloud_firestore.dart';

/// Represents a snapshot of a cart item captured at the time an order is placed.
/// Immutable — prices/quantities are locked in at the moment of checkout.
class OrderItem {
  final int? productId;
  final String title;
  final String brand;
  final String imageUrl;
  final String? category;
  final String size;
  final double unitPrice;
  final int quantity;
  final double lineTotal;

  const OrderItem({
    this.productId,
    required this.title,
    required this.brand,
    required this.imageUrl,
    this.category,
    required this.size,
    required this.unitPrice,
    required this.quantity,
    required this.lineTotal,
  });

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'title': title,
      'brand': brand,
      'imageUrl': imageUrl,
      'category': category,
      'size': size,
      'unitPrice': unitPrice,
      'quantity': quantity,
      'lineTotal': lineTotal,
    };
  }
}

/// Configurable delivery fee settings.
/// Change [flatDeliveryFee] when business defines real delivery pricing.
class DeliveryFeePolicy {
  // TODO(business): Replace with real delivery fee logic when pricing is defined.
  static const double flatDeliveryFee = 5.00;
  static const String currency = 'USD';

  /// Returns the applicable delivery fee for a given subtotal.
  /// Currently a flat fee. Extend this method for distance/weight-based pricing.
  static double calculateFee(double subtotal) {
    if (subtotal <= 0) return 0.0;
    return flatDeliveryFee;
  }
}

/// Payment method enum for checkout.
enum PaymentMethod {
  cashOnDelivery,
  onlinePayment; // Coming soon — no provider configured yet

  String get displayName {
    switch (this) {
      case PaymentMethod.cashOnDelivery:
        return 'Cash on Delivery';
      case PaymentMethod.onlinePayment:
        return 'Online Payment (Coming Soon)';
    }
  }

  String get firestoreKey {
    switch (this) {
      case PaymentMethod.cashOnDelivery:
        return 'CASH_ON_DELIVERY';
      case PaymentMethod.onlinePayment:
        return 'ONLINE_PAYMENT';
    }
  }
}

/// Represents the full order document written to Firestore.
class OrderModel {
  final String? orderId;
  final String userId;
  final String customerName;
  final String phoneNumber;
  final String city;
  final String deliveryAddress;
  final String? deliveryInstructions;
  final List<OrderItem> items;
  final double subtotal;
  final double deliveryFee;
  final double total;
  final String currency;
  final PaymentMethod paymentMethod;
  final String paymentStatus; // 'PENDING', 'PAID', 'FAILED'
  final String orderStatus;   // 'PLACED', 'PROCESSING', 'SHIPPED', 'DELIVERED', 'CANCELLED'
  final DateTime? placedAt;

  const OrderModel({
    this.orderId,
    required this.userId,
    required this.customerName,
    required this.phoneNumber,
    required this.city,
    required this.deliveryAddress,
    this.deliveryInstructions,
    required this.items,
    required this.subtotal,
    required this.deliveryFee,
    required this.total,
    required this.currency,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.orderStatus,
    this.placedAt,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'customerName': customerName,
      'phoneNumber': phoneNumber,
      'city': city,
      'deliveryAddress': deliveryAddress,
      'deliveryInstructions': deliveryInstructions,
      'items': items.map((item) => item.toMap()).toList(),
      'subtotal': subtotal,
      'deliveryFee': deliveryFee,
      'total': total,
      'currency': currency,
      'paymentMethod': paymentMethod.firestoreKey,
      'paymentStatus': paymentStatus,
      'orderStatus': orderStatus,
      'placedAt': FieldValue.serverTimestamp(),
      'clientCreatedAt': DateTime.now().millisecondsSinceEpoch,
    };
  }
}
