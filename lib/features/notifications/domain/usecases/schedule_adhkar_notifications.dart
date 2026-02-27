import '../entities/adhkar_notification_settings.dart';
import '../repositories/notification_repository.dart';

class ScheduleAdhkarNotifications {
  final NotificationRepository _repository;

  ScheduleAdhkarNotifications(this._repository);

  Future<void> call(AdhkarNotificationSettings settings) {
    return _repository.scheduleAdhkarNotifications(settings);
  }
}
