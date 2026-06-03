import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class PushNotificationService {
  static final FlutterLocalNotificationsPlugin _localNotifications =
  FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');

    const initSettings = InitializationSettings(
      android: androidInit,
    );

    await _localNotifications.initialize(initSettings);

    const channel = AndroidNotificationChannel(
      'social_channel',
      'Thông báo cộng đồng',
      description: 'Thông báo bình luận và phản hồi trong diễn đàn',
      importance: Importance.high,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final notification = message.notification;

      if (notification == null) return;

      _localNotifications.show(
        notification.hashCode,
        notification.title,
        notification.body,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'social_channel',
            'Thông báo cộng đồng',
            channelDescription:
            'Thông báo bình luận và phản hồi trong diễn đàn',
            importance: Importance.high,
            priority: Priority.high,
          ),
        ),
      );
    });
  }
}