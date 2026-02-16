import 'dart:convert';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:nafausa/features/gallery/view/gallery_detail_screen.dart';
import 'package:nafausa/features/notification/view/notification_screen.dart';

import '../../app/utils/constants.dart';
import '../../features/events/view/events_detail_screen.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Function(RemoteMessage)? onMessageOpenedApp;
  Function(RemoteMessage)? onForegroundMessage;
  Function(String?)? onTokenRefresh;

  Future<void> initialize() async {
    await _setupFirebaseMessaging();
    await _setupLocalNotifications();
    getFCMToken();
  }

  Future<void> _setupFirebaseMessaging() async {
    // Request notification permissions
    //subcribe to topic all

    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint('Notification permission granted');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      debugPrint('Notification provisional permission granted');
    } else {
      debugPrint('Notification permission denied');
    }
    _firebaseMessaging.onTokenRefresh.listen((newToken) {
      debugPrint('New FCM Token: $newToken');
      onTokenRefresh?.call(newToken);
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('Got a message whilst in the foreground!');
      debugPrint('Message data: ${message.data}');

      if (message.notification != null) {
        debugPrint('Message notification: ${message.notification}');
        _showLocalNotification(message);
      }

      onForegroundMessage?.call(message);
    });

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    await setForegroundNotificationPresentationOptions(
      alert: false,
      badge: true,
      sound: false,
    );
  }

  Future<void> _setupLocalNotifications() async {
    subscribeToTopic('all');
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse details) {
        onDidReceiveNotificationResponse(Get.context ?? cusCtx!, details);
      },
    );

    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(alert: true, badge: true, sound: true);
  }

  Future<void> setupInteractMessage(BuildContext context) async {
    // when app is terminated
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      // ignore: use_build_context_synchronously
      handleMessage(context, initialMessage);
    }

    //when app ins background
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      // ignore: use_build_context_synchronously
      handleMessage(context, event);
    });
  }

  static void handleMessage(BuildContext context, RemoteMessage message) async {
    switch (message.data['type']) {
      case "gallery":
        Get.to(() => GalleryDetailScreen(
            title: message.data['title'],
            galleryId: message.data['id'],
            thumbnail: message.data['thumbnail']));
        break;
      case "event":
        Get.to(() => EventDetailScreen(
            title: message.data['title'],
            eventId: message.data['id'],
            thumbnail: message.data['thumbnail']));
      default:
        Get.to(() => const NotificationScreen());
    }
  }

  Future<void> _showLocalNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      channelDescription: 'your_channel_description',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );

    const DarwinNotificationDetails iosPlatformChannelSpecifics =
        DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iosPlatformChannelSpecifics,
    );

    await _flutterLocalNotificationsPlugin.show(
      message.hashCode,
      message.notification?.title ?? 'Default Title',
      message.notification?.body ?? 'Default Body',
      platformChannelSpecifics,
      payload: json.encode(message.data),
    );
  }

  // Add onDidReceiveNotificationResponse to handle notification tap
  void onDidReceiveNotificationResponse(
    BuildContext context,
    NotificationResponse details,
  ) {
    if (details.payload != null) {
      final Map<String, dynamic> data = json.decode(details.payload!);
      final RemoteMessage message = RemoteMessage(data: data);
      handleMessage(context, message);
    }
  }

  Future<void> setForegroundNotificationPresentationOptions({
    bool alert = false,
    bool badge = true,
    bool sound = false,
  }) async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: alert,
      badge: badge,
      sound: sound,
    );
  }

  Future<String?> getFCMToken() async {
    if (Platform.isIOS) {
      await _firebaseMessaging.getAPNSToken();
    }
    String? token = await _firebaseMessaging.getToken();
    debugPrint("FCM Token: $token");
    subscribeToTopic('all');
    return token;
  }

  Future<void> deleteFCMToken() async {
    await _firebaseMessaging.deleteToken();
  }

  Future<void> subscribeToTopic(String topic) async {
    await _firebaseMessaging.subscribeToTopic(topic);
  }

  Future<void> unsubscribeFromTopic(String topic) async {
    await _firebaseMessaging.unsubscribeFromTopic(topic);
  }
}

// Top-level background message handler
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  debugPrint("Handling a background message: ${message.messageId}");
  await NotificationService()._showLocalNotification(message);
}
