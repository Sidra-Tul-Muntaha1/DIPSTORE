import 'dart:async';
import 'package:DIPSTORE/Model.dart/notification_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class NotificationController extends GetxController {
  final notifications = <AppNotification>[].obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  FirebaseAuth get _auth => FirebaseAuth.instance;
  FirebaseFirestore get _firestore => FirebaseFirestore.instance;

  StreamSubscription? _subscription;

  User? get currentUser => _auth.currentUser;
  bool get isSignedIn => currentUser != null;

  int get unreadCount => notifications.where((n) => !n.isRead).length;

  @override
  void onInit() {
    super.onInit();
    _auth.authStateChanges().listen((user) {
      if (user != null) {
        _subscribeToNotifications(user.uid);
      } else {
        _subscription?.cancel();
        notifications.clear();
      }
    });
  }

  @override
  void onClose() {
    _subscription?.cancel();
    super.onClose();
  }

  void _subscribeToNotifications(String uid) {
    _subscription?.cancel();
    isLoading.value = true;
    errorMessage.value = '';

    try {
      _subscription = _firestore
          .collection('users')
          .doc(uid)
          .collection('notifications')
          .orderBy('createdAt', descending: true)
          .snapshots()
          .listen(
        (snapshot) {
          notifications.value = snapshot.docs
              .map((doc) => AppNotification.fromFirestore(doc))
              .toList();
          isLoading.value = false;
        },
        onError: (err) {
          errorMessage.value = err.toString();
          isLoading.value = false;
        },
      );
    } catch (e) {
      errorMessage.value = e.toString();
      isLoading.value = false;
    }
  }

  Future<void> markAsRead(String notificationId) async {
    final user = currentUser;
    if (user == null) return;
    try {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('notifications')
          .doc(notificationId)
          .update({'isRead': true});
    } catch (_) {}
  }

  Future<void> markAllAsRead() async {
    final user = currentUser;
    if (user == null) return;
    try {
      final unreadDocs = notifications.where((n) => !n.isRead).toList();
      final batch = _firestore.batch();
      for (final n in unreadDocs) {
        final ref = _firestore
            .collection('users')
            .doc(user.uid)
            .collection('notifications')
            .doc(n.id);
        batch.update(ref, {'isRead': true});
      }
      await batch.commit();
    } catch (_) {}
  }
}
