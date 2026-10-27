
import 'package:DIPSTORE/Controller.dart/notification_controller.dart';
import 'package:DIPSTORE/Model.dart/notification_model.dart';
import 'package:DIPSTORE/signin.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class Notific extends StatelessWidget {
  const Notific({super.key});

  IconData _iconForType(String type) {
    switch (type) {
      case 'ORDER_PLACED':
        return Icons.shopping_bag_outlined;
      case 'ORDER_STATUS_CHANGED':
        return Icons.local_shipping_outlined;
      case 'DELIVERY_UPDATE':
        return Icons.check_circle_outline;
      case 'PROMO':
        return Icons.local_offer_outlined;
      case 'WELCOME':
        return Icons.celebration_outlined;
      default:
        return Icons.notifications_outlined;
    }
  }

  Color _colorForType(String type) {
    switch (type) {
      case 'ORDER_PLACED':
        return const Color.fromARGB(255, 36, 14, 5);
      case 'ORDER_STATUS_CHANGED':
        return const Color(0xFF1E88E5);
      case 'DELIVERY_UPDATE':
        return const Color(0xFF2E7D32);
      case 'PROMO':
        return const Color(0xFFEF6C00);
      case 'WELCOME':
        return const Color(0xFF8E24AA);
      default:
        return Colors.brown;
    }
  }

  String _formatTimestamp(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inSeconds < 60) {
      return 'Just now';
    } else if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}h ago';
    } else if (diff.inDays == 1) {
      return 'Yesterday';
    } else if (diff.inDays < 7) {
      return '${diff.inDays}d ago';
    } else {
      return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';
    }
  }

  @override
  Widget build(BuildContext context) {
    final NotificationController notifController =
        Get.isRegistered<NotificationController>()
            ? Get.find<NotificationController>()
            : Get.put(NotificationController());

    return Scaffold(
      backgroundColor: const Color(0xFFFEEFE3),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Obx(() {
          final unread = notifController.unreadCount;
          return Text(
            unread > 0 ? 'Notifications ($unread)' : 'Notifications',
            style: GoogleFonts.aBeeZee(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          );
        }),
        centerTitle: true,
        actions: [
          Obx(() {
            if (!notifController.isSignedIn || notifController.unreadCount == 0) {
              return const SizedBox.shrink();
            }
            return TextButton(
              onPressed: () => notifController.markAllAsRead(),
              child: const Text(
                'Mark all read',
                style: TextStyle(
                  color: Colors.brown,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            );
          }),
        ],
      ),
      body: Obx(() {
        if (!notifController.isSignedIn) {
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
                      Icons.notifications_off_outlined,
                      size: 40,
                      color: Colors.brown,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Sign in for Notifications',
                    style: GoogleFonts.aBeeZee(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(255, 36, 14, 5),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Sign in to track orders, deliveries, and receive exclusive DIPSTORE updates.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 36, 14, 5),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const Signin()),
                      );
                    },
                    child: const Text(
                      'Sign In',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        if (notifController.isLoading.value &&
            notifController.notifications.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.brown),
          );
        }

        if (notifController.errorMessage.isNotEmpty &&
            notifController.notifications.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 48,
                    color: Colors.brown,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Unable to load notifications',
                    style: GoogleFonts.aBeeZee(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    notifController.errorMessage.value,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ),
          );
        }

        if (notifController.notifications.isEmpty) {
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
                      Icons.notifications_none_outlined,
                      size: 40,
                      color: Colors.brown,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'No Notifications Yet',
                    style: GoogleFonts.aBeeZee(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(255, 36, 14, 5),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Updates on your orders and exclusive offers will appear here.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                ],
              ),
            ),
          );
        }

        final items = notifController.notifications;

        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          itemCount: items.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final AppNotification item = items[index];
            final icon = _iconForType(item.type);
            final color = _colorForType(item.type);
            final timeAgo = _formatTimestamp(item.createdAt);

            return InkWell(
              onTap: () {
                if (!item.isRead) {
                  notifController.markAsRead(item.id);
                }
              },
              borderRadius: BorderRadius.circular(14),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: item.isRead
                      ? Colors.white
                      : const Color(0xFFFFFBF8),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: item.isRead
                        ? Colors.black.withOpacity(0.04)
                        : const Color.fromARGB(255, 215, 183, 171),
                    width: item.isRead ? 1 : 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Notification type icon
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.12),
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Icon(icon, color: color, size: 22),
                    ),
                    const SizedBox(width: 12),
                    // Content
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  item.title,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: item.isRead
                                        ? FontWeight.w600
                                        : FontWeight.bold,
                                    color: const Color.fromARGB(255, 36, 14, 5),
                                  ),
                                ),
                              ),
                              if (!item.isRead)
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.brown,
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item.message,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade700,
                              height: 1.35,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              if (item.orderId != null &&
                                  item.orderId!.isNotEmpty)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF2ECEC),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    '#${item.orderId!.length >= 8 ? item.orderId!.substring(0, 8).toUpperCase() : item.orderId!.toUpperCase()}',
                                    style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.brown,
                                    ),
                                  ),
                                )
                              else
                                const SizedBox.shrink(),
                              Text(
                                timeAgo,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey.shade500,
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
