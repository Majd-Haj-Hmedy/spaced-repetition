import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  final notificationsPlugin = FlutterLocalNotificationsPlugin();
  Future<void> initNotification() async {
    const androidInitializationSettings =
        AndroidInitializationSettings('@drawable/repet_logo');

    final iosInitializationSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification: (id, title, body, payload) async {},
    );

    final initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitializationSettings,
    );

    // Initialize the time zone database
    tz.initializeTimeZones();

    await notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) async {},
    );
  }

  Future<bool> isPermissionGranted({required BuildContext context}) async {
    final permissionStatus = await Permission.notification.request();
    if (permissionStatus.isDenied) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Permission denied'),
            action: SnackBarAction(
              label: 'Settings',
              onPressed: () async => await openAppSettings(),
            ),
          ),
        );
      }
      return false;
    } else if (permissionStatus.isPermanentlyDenied) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Permission denied'),
            action: SnackBarAction(
              label: 'Settings',
              onPressed: () async => await openAppSettings(),
            ),
          ),
        );
      }
      return false;
    }
    return true;
  }

  Future<void> showScheduledNotification({
    required int id,
    required String title,
    required String body,
    required DateTime dateTime,
  }) async {
    notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(dateTime, tz.local),
      notificationDetails,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<void> cancelAllNotifications() async {
    notificationsPlugin.cancelAll();
  }

  Future<void> requestPermission() async {
    await notificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()!
        .requestPermission();
  }

  NotificationDetails get notificationDetails {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'repet_daily_notifications',
        'Lectures Reminder',
        importance: Importance.max,
      ),
      iOS: DarwinNotificationDetails(),
    );
  }
}
