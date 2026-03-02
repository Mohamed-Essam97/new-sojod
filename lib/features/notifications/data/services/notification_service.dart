import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

import '../../../../features/prayer/domain/entities/prayer_time_entity.dart';
import '../../domain/entities/adhkar_notification_settings.dart';
import '../../domain/entities/prayer_notification_settings.dart';

/// Notification IDs: Fajr 100, Dhuhr 101, Asr 102, Maghrib 103, Isha 104
/// Morning Adhkar 200, Evening Adhkar 201, Sleep Adhkar 202
class NotificationService {
  static const String _channelId = 'al_mumin_notifications';
  static const String _channelName = 'Wird Reminders';

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;
    tz_data.initializeTimeZones();
    try {
      tz.setLocalLocation(tz.getLocation(tz.local.name));
    } catch (_) {
      tz.setLocalLocation(tz.getLocation('UTC'));
    }

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings();
    const initSettings = InitializationSettings(
      android: android,
      iOS: ios,
    );

    await _plugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    if (Platform.isAndroid) {
      await _plugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(
            const AndroidNotificationChannel(
              _channelId,
              _channelName,
              description: 'Prayer times and Adhkar reminders',
              importance: Importance.high,
            ),
          );
    }
    _initialized = true;
  }

  void _onNotificationTapped(NotificationResponse response) {
    // Could navigate to prayer/adhkar screen
  }

  Future<bool> requestPermissions() async {
    if (Platform.isAndroid) {
      // Android 13+ POST_NOTIFICATIONS
      var notifStatus = await Permission.notification.status;
      if (!notifStatus.isGranted) {
        notifStatus = await Permission.notification.request();
        if (!notifStatus.isGranted) return false;
      }

      // Android 12+ SCHEDULE_EXACT_ALARM for accurate prayer times
      var exactAlarmStatus = await Permission.scheduleExactAlarm.status;
      if (!exactAlarmStatus.isGranted) {
        exactAlarmStatus = await Permission.scheduleExactAlarm.request();
        if (!exactAlarmStatus.isGranted) return false;
      }

      final androidInfo =
          await _plugin.resolvePlatformSpecificImplementation<
                  AndroidFlutterLocalNotificationsPlugin>()
              ?.requestNotificationsPermission();
      if (androidInfo != null && !androidInfo) return false;
    } else if (Platform.isIOS) {
      final iosPlugin = _plugin.resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>();
      final granted = await iosPlugin?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          ) ??
          false;
      if (!granted) return false;
    }
    return true;
  }

  Future<void> schedulePrayerNotifications(
    List<PrayerTimesEntity> timesForDays,
    PrayerNotificationSettings settings,
  ) async {
    await _cancelPrayerNotifications();

    final details = _prayerNotificationDetails();
    for (var d = 0; d < timesForDays.length; d++) {
      final day = timesForDays[d];

      if (settings.fajrEnabled && day.fajr.isAfter(DateTime.now())) {
        await _schedule(
          id: 100 + d * 5 + 0,
          scheduledDate: _toTZ(day.fajr),
          title: 'Fajr',
          body: 'Time for Fajr prayer',
          details: details,
        );
      }
      if (settings.dhuhrEnabled && day.dhuhr.isAfter(DateTime.now())) {
        await _schedule(
          id: 100 + d * 5 + 1,
          scheduledDate: _toTZ(day.dhuhr),
          title: 'Dhuhr',
          body: 'Time for Dhuhr prayer',
          details: details,
        );
      }
      if (settings.asrEnabled && day.asr.isAfter(DateTime.now())) {
        await _schedule(
          id: 100 + d * 5 + 2,
          scheduledDate: _toTZ(day.asr),
          title: 'Asr',
          body: 'Time for Asr prayer',
          details: details,
        );
      }
      if (settings.maghribEnabled && day.maghrib.isAfter(DateTime.now())) {
        await _schedule(
          id: 100 + d * 5 + 3,
          scheduledDate: _toTZ(day.maghrib),
          title: 'Maghrib',
          body: 'Time for Maghrib prayer',
          details: details,
        );
      }
      if (settings.ishaEnabled && day.isha.isAfter(DateTime.now())) {
        await _schedule(
          id: 100 + d * 5 + 4,
          scheduledDate: _toTZ(day.isha),
          title: 'Isha',
          body: 'Time for Isha prayer',
          details: details,
        );
      }
    }
  }

  Future<void> _cancelPrayerNotifications() async {
    for (var id = 100; id <= 199; id++) {
      await _plugin.cancel(id);
    }
  }

  Future<void> scheduleAdhkarNotifications(
    AdhkarNotificationSettings settings,
  ) async {
    await _cancelAdhkarNotifications();

    final details = _adhkarNotificationDetails();

    if (settings.morningEnabled) {
      await _scheduleDaily(
        id: 200,
        hour: settings.morningTime.hour,
        minute: settings.morningTime.minute,
        titleKey: 'notifTitleMorning',
        bodyKey: 'notifBodyMorning',
        details: details,
      );
    }
    if (settings.eveningEnabled) {
      await _scheduleDaily(
        id: 201,
        hour: settings.eveningTime.hour,
        minute: settings.eveningTime.minute,
        titleKey: 'notifTitleEvening',
        bodyKey: 'notifBodyEvening',
        details: details,
      );
    }
    if (settings.sleepEnabled) {
      var h = settings.sleepTime.hour;
      var m = settings.sleepTime.minute;
      if (m >= 10) {
        m -= 10;
      } else {
        m = m + 50;
        h = h > 0 ? h - 1 : 23;
      }
      await _scheduleDaily(
        id: 202,
        hour: h,
        minute: m,
        titleKey: 'notifTitleSleep',
        bodyKey: 'notifBodySleep',
        details: details,
      );
    }
  }

  Future<void> _cancelAdhkarNotifications() async {
    for (var id = 200; id <= 202; id++) {
      await _plugin.cancel(id);
    }
  }

  Future<void> _schedule({
    required int id,
    required tz.TZDateTime scheduledDate,
    required String title,
    required String body,
    required NotificationDetails details,
  }) async {
    await _plugin.zonedSchedule(
      id,
      title,
      body,
      scheduledDate,
      details,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  Future<void> _scheduleDaily({
    required int id,
    required int hour,
    required int minute,
    required String titleKey,
    required String bodyKey,
    required NotificationDetails details,
  }) async {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }

    await _plugin.zonedSchedule(
      id,
      _localizedTitle(titleKey),
      _localizedBody(bodyKey),
      scheduled,
      details,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  String _localizedTitle(String key) {
    switch (key) {
      case 'notifTitleMorning':
        return 'Morning Adhkar';
      case 'notifTitleEvening':
        return 'Evening Adhkar';
      case 'notifTitleSleep':
        return 'Sleep Adhkar';
      default:
        return 'Reminder';
    }
  }

  String _localizedBody(String key) {
    switch (key) {
      case 'notifBodyMorning':
        return 'Start your day with the remembrance of Allah';
      case 'notifBodyEvening':
        return 'End your day with the remembrance of Allah';
      case 'notifBodySleep':
        return 'Do not forget the sleep adhkar before you sleep';
      default:
        return '';
    }
  }

  tz.TZDateTime _toTZ(DateTime dt) {
    return tz.TZDateTime.from(dt, tz.local);
  }

  NotificationDetails _prayerNotificationDetails() {
    return NotificationDetails(
      android: AndroidNotificationDetails(
        _channelId,
        _channelName,
        channelDescription: 'Prayer time reminders',
        importance: Importance.high,
        priority: Priority.high,
      ),
      iOS: const DarwinNotificationDetails(),
    );
  }

  NotificationDetails _adhkarNotificationDetails() {
    return NotificationDetails(
      android: AndroidNotificationDetails(
        _channelId,
        _channelName,
        channelDescription: 'Adhkar reminders',
        importance: Importance.high,
        priority: Priority.high,
      ),
      iOS: const DarwinNotificationDetails(),
    );
  }

  /// Schedule a one-off test notification after [delay].
  Future<void> scheduleTestNotification(Duration delay) async {
    await initialize();
    final when = tz.TZDateTime.now(tz.local).add(delay);
    final details = _prayerNotificationDetails();
    await _plugin.zonedSchedule(
      999, // dedicated test ID
      'Test notification',
      'This is a test reminder from Wird',
      when,
      details,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  Future<void> cancelAll() async {
    await _cancelPrayerNotifications();
    await _cancelAdhkarNotifications();
  }
}
