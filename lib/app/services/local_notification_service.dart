import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

import '../shared/globals.dart';

//Notification class responsible for managing local notifications
class LocalNotification {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  FlutterLocalNotificationsPlatform flutterLocalNotificationsPlatform =
      FlutterLocalNotificationsPlatform.instance;

  final bool _isInitialized = false;

  bool _permissionGranted = false;

  bool? _exactAlarmsPermission;

  bool get isInitialized => _isInitialized;
  bool get permissionGranted => _permissionGranted;
  bool? get exactAlarmsPermission => _exactAlarmsPermission;

  Future init() async {
    // Prevent re-initializing
    if (_isInitialized) return;

    //Android initialization settings
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher'); //Default app icon

    //IOS initialization settings
    const DarwinInitializationSettings darwinInitializationSettings =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );

    //Initialization settings
    const InitializationSettings initializationSettings =
        InitializationSettings(
          android: androidInitializationSettings,
          iOS: darwinInitializationSettings,
        );

    //Request notification permissions
    bool? result = await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );

    // Check if running on Android and request permission
    if (!isIOS) {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
          flutterLocalNotificationsPlugin
              .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin
              >();

      if (androidImplementation != null) {
        result = await androidImplementation.requestNotificationsPermission();

        final bool? granted = await androidImplementation
            .requestExactAlarmsPermission();

        if (granted != null && granted) {
          // Permission granted, proceed with exact alarms
          _exactAlarmsPermission = true;
        } else {
          // Permission denied, handle accordingly (e.g., inform the user)
        }
      }
    } else {
      result = await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >()
          ?.requestPermissions(alert: true, badge: true, sound: true);
    }

    if (result == true) {
      _permissionGranted = true;
    }

    logger.d("Notification permission granted: $_permissionGranted");
  }

  NotificationDetails notificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        "toDoChannelId",
        "Todo Notifications",
        channelDescription: "ToDo Notifications",
        importance: Importance.max,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
    );
  }

  void showNotification({
    int id = 0,
    required String title,
    required String body,
    dynamic payload,
  }) async {
    await flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      notificationDetails(),
      payload: payload,
    );
  }

  /// Schedule a notification at a specific date & time
  Future<void> scheduleTaskNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    required TimeOfDay scheduledTime,
  }) async {
    // Combine date + time into a tz.TZDateTime
    final scheduledDateTime = tz.TZDateTime.from(
      DateTime(
        scheduledDate.year,
        scheduledDate.month,
        scheduledDate.day,
        scheduledTime.hour,
        scheduledTime.minute,
      ),
      tz.local,
    );

    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      scheduledDateTime,
      NotificationDetails(
        android: AndroidNotificationDetails(
          'task_channel_id',
          'Task Notifications',
          channelDescription: 'Notifications to remind about tasks',
          importance: Importance.max,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),

      matchDateTimeComponents: DateTimeComponents.dateAndTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
    logger.d("Task scheduled successfully");
  }

  //Schedule notification every day
  Future<void> scheduleDailyAtTime({
    required int id,
    required String title,
    required String body,
    required int hour,
    required int minute,
  }) async {
    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    // If the time is already past today, schedule for tomorrow
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      scheduledDate,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_channel',
          'Daily Notifications',
          channelDescription: 'Notifies you daily at a precise time',
          importance: Importance.max,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      matchDateTimeComponents:
          DateTimeComponents.time, // 👈 repeat daily at same time
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
    logger.d("Task scheduled successfully");
  }

  //Cancel specific scheduled notification based on id
  Future<void> cancel(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  //Cancel all scheduled notifications
  Future<void> cancelAll() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}
