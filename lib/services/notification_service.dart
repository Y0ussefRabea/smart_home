import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static int notificationId = 0;
  static final FlutterLocalNotificationsPlugin notificationsPlugin =
  FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    const AndroidInitializationSettings androidSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
    InitializationSettings(
      android: androidSettings,
    );

    await notificationsPlugin.initialize(
      settings: initializationSettings,
    );
  }

  static Future<void> showNotification({
    required String title,
    required String body,
  }) async {
    const AndroidNotificationDetails androidDetails =
    AndroidNotificationDetails(
      'smart_home_alerts',
      'Smart Home Alerts',
      channelDescription: 'Smart Home Notifications',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails details =
    NotificationDetails(
      android: androidDetails,
    );

    await notificationsPlugin.show(
      id: notificationId++,
      title: title,
      body: body,
      notificationDetails: details,
    );
  }
}