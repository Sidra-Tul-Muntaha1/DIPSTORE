import 'package:cloud_firestore/cloud_firestore.dart';

class AppNotification {
  final String id;
  final String title;
  final String message;
  final String type; // 'ORDER_PLACED', 'ORDER_STATUS_CHANGED', 'DELIVERY_UPDATE', 'PROMO', 'WELCOME'
  final String? orderId;
  final bool isRead;
  final DateTime createdAt;

  const AppNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    this.orderId,
    required this.isRead,
    required this.createdAt,
  });

  factory AppNotification.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    final ts = data['createdAt'];
    DateTime date = DateTime.now();
    if (ts is Timestamp) {
      date = ts.toDate();
    } else if (ts is int) {
      date = DateTime.fromMillisecondsSinceEpoch(ts);
    }
    return AppNotification(
      id: doc.id,
      title: data['title']?.toString() ?? 'Notification',
      message: data['message']?.toString() ?? '',
      type: data['type']?.toString() ?? 'ORDER_PLACED',
      orderId: data['orderId']?.toString(),
      isRead: data['isRead'] == true,
      createdAt: date,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'message': message,
      'type': type,
      'orderId': orderId,
      'isRead': isRead,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}
