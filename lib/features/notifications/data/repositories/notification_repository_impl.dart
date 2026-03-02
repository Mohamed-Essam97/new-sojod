import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../features/prayer/domain/entities/prayer_time_entity.dart';
import '../../domain/entities/adhkar_notification_settings.dart';
import '../../domain/entities/prayer_notification_settings.dart';
import '../../domain/repositories/notification_repository.dart';
import '../services/notification_service.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final SharedPreferences _prefs;
  final NotificationService _service;

  NotificationRepositoryImpl({
    required SharedPreferences prefs,
    required NotificationService service,
  })  : _prefs = prefs,
        _service = service;

  @override
  Future<PrayerNotificationSettings> getPrayerSettings() async {
    await _service.initialize();
    return PrayerNotificationSettings(
      fajrEnabled: _prefs.getBool(AppConstants.keyPrayerNotifFajr) ?? true,
      dhuhrEnabled: _prefs.getBool(AppConstants.keyPrayerNotifDhuhr) ?? true,
      asrEnabled: _prefs.getBool(AppConstants.keyPrayerNotifAsr) ?? true,
      maghribEnabled:
          _prefs.getBool(AppConstants.keyPrayerNotifMaghrib) ?? true,
      ishaEnabled: _prefs.getBool(AppConstants.keyPrayerNotifIsha) ?? true,
    );
  }

  @override
  Future<void> savePrayerSettings(PrayerNotificationSettings settings) async {
    await _prefs.setBool(AppConstants.keyPrayerNotifFajr, settings.fajrEnabled);
    await _prefs.setBool(
        AppConstants.keyPrayerNotifDhuhr, settings.dhuhrEnabled);
    await _prefs.setBool(AppConstants.keyPrayerNotifAsr, settings.asrEnabled);
    await _prefs.setBool(
        AppConstants.keyPrayerNotifMaghrib, settings.maghribEnabled);
    await _prefs.setBool(AppConstants.keyPrayerNotifIsha, settings.ishaEnabled);
  }

  @override
  Future<AdhkarNotificationSettings> getAdhkarSettings() async {
    await _service.initialize();
    return AdhkarNotificationSettings(
      morningEnabled:
          _prefs.getBool(AppConstants.keyAdhkarMorningEnabled) ?? false,
      morningTime: TimeOfDay(
        hour: _prefs.getInt(AppConstants.keyAdhkarMorningHour) ?? 7,
        minute: _prefs.getInt(AppConstants.keyAdhkarMorningMinute) ?? 0,
      ),
      eveningEnabled:
          _prefs.getBool(AppConstants.keyAdhkarEveningEnabled) ?? false,
      eveningTime: TimeOfDay(
        hour: _prefs.getInt(AppConstants.keyAdhkarEveningHour) ?? 17,
        minute: _prefs.getInt(AppConstants.keyAdhkarEveningMinute) ?? 0,
      ),
      sleepEnabled:
          _prefs.getBool(AppConstants.keyAdhkarSleepEnabled) ?? false,
      sleepTime: TimeOfDay(
        hour: _prefs.getInt(AppConstants.keyAdhkarSleepHour) ?? 23,
        minute: _prefs.getInt(AppConstants.keyAdhkarSleepMinute) ?? 0,
      ),
    );
  }

  @override
  Future<void> saveAdhkarSettings(AdhkarNotificationSettings settings) async {
    await _prefs.setBool(
        AppConstants.keyAdhkarMorningEnabled, settings.morningEnabled);
    await _prefs.setInt(
        AppConstants.keyAdhkarMorningHour, settings.morningTime.hour);
    await _prefs.setInt(
        AppConstants.keyAdhkarMorningMinute, settings.morningTime.minute);
    await _prefs.setBool(
        AppConstants.keyAdhkarEveningEnabled, settings.eveningEnabled);
    await _prefs.setInt(
        AppConstants.keyAdhkarEveningHour, settings.eveningTime.hour);
    await _prefs.setInt(
        AppConstants.keyAdhkarEveningMinute, settings.eveningTime.minute);
    await _prefs.setBool(
        AppConstants.keyAdhkarSleepEnabled, settings.sleepEnabled);
    await _prefs.setInt(
        AppConstants.keyAdhkarSleepHour, settings.sleepTime.hour);
    await _prefs.setInt(
        AppConstants.keyAdhkarSleepMinute, settings.sleepTime.minute);
  }

  @override
  Future<bool> requestPermissions() async {
    return _service.requestPermissions();
  }

  @override
  Future<void> scheduleTestNotification(Duration delay) async {
    await _service.initialize();
    await _service.scheduleTestNotification(delay);
  }

  @override
  Future<void> schedulePrayerNotifications(
    List<PrayerTimesEntity> timesForDays,
    PrayerNotificationSettings settings,
  ) async {
    await _service.initialize();
    await _service.schedulePrayerNotifications(timesForDays, settings);
  }

  @override
  Future<void> scheduleAdhkarNotifications(
    AdhkarNotificationSettings settings,
  ) async {
    await _service.initialize();
    await _service.scheduleAdhkarNotifications(settings);
  }

  @override
  Future<void> cancelAll() async {
    await _service.initialize();
    await _service.cancelAll();
  }
}
