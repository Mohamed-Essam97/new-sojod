import '../../../../features/prayer/domain/entities/prayer_time_entity.dart';
import '../entities/prayer_notification_settings.dart';
import '../repositories/notification_repository.dart';

class SchedulePrayerNotifications {
  final NotificationRepository _repository;

  SchedulePrayerNotifications(this._repository);

  Future<void> call(
    List<PrayerTimesEntity> timesForDays,
    PrayerNotificationSettings settings,
  ) {
    return _repository.schedulePrayerNotifications(
      timesForDays,
      settings,
    );
  }
}
