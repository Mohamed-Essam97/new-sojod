import '../entities/adhkar_notification_settings.dart';
import '../entities/prayer_notification_settings.dart';
import '../../../../features/prayer/domain/entities/prayer_time_entity.dart';

abstract class NotificationRepository {
  Future<PrayerNotificationSettings> getPrayerSettings();
  Future<void> savePrayerSettings(PrayerNotificationSettings settings);

  Future<AdhkarNotificationSettings> getAdhkarSettings();
  Future<void> saveAdhkarSettings(AdhkarNotificationSettings settings);

  Future<bool> requestPermissions();

  Future<void> schedulePrayerNotifications(
    List<PrayerTimesEntity> timesForDays,
    PrayerNotificationSettings settings,
  );

  Future<void> scheduleAdhkarNotifications(
    AdhkarNotificationSettings settings,
  );

  Future<void> cancelAll();
}
