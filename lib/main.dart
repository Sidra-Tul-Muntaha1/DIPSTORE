import 'package:DIPSTORE/Controller.dart/cart_controller.dart';
import 'package:DIPSTORE/Controller.dart/checkout_controller.dart';
import 'package:DIPSTORE/Controller.dart/favourite_controller.dart';
import 'package:DIPSTORE/Controller.dart/get_controller.dart';
import 'package:DIPSTORE/Controller.dart/notification_controller.dart';
import 'package:DIPSTORE/Controller.dart/product_controller.dart';
import 'package:DIPSTORE/Controller.dart/profile_controller.dart';
import 'package:DIPSTORE/firebase_options.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:DIPSTORE/Projectscreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  initialize();
  listenNotification();
  Get.put(GetController());
  Get.put(ProductController());
  Get.put(CartController());
  Get.put(CheckoutController());
  Get.put(FavouriteController());
  Get.put(NotificationController());
  Get.put(ProfileController());
  runApp(const App());
}

void listenNotification() {
  AwesomeNotifications().requestPermissionToSendNotifications();
  FirebaseMessaging.onBackgroundMessage((message) async {
    AwesomeNotifications().createNotificationFromJsonData(message.data);
  });

  FirebaseMessaging.onMessage.listen((message) {
    AwesomeNotifications().createNotificationFromJsonData(message.data);
  });
}

void initialize() async {
  AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
            channelGroupKey: 'basic_channel_group',
            channelKey: 'basic_channel',
            channelName: 'Basic notifications',
            channelDescription: 'Notification channel for basic tests',
            defaultColor: const Color(0xFF9D50DD),
            ledColor: Colors.white)
      ],
      channelGroups: [
        NotificationChannelGroup(
            channelGroupKey: 'basic_channel_group',
            channelGroupName: 'Basic group')
      ],
      debug: true);
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'DIPSTORE',
      theme: ThemeData.from(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
        ),
        useMaterial3: false,
      ),
      darkTheme: ThemeData.from(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          surface: Colors.black,
        ),
        useMaterial3: false,
      ),
      debugShowCheckedModeBanner: false,
      home: const Projectscreen(),
    );
  }
}
