import '../repositories/notification_repository.dart';

class CancelAllNotifications {
  final NotificationRepository _repository;

  CancelAllNotifications(this._repository);

  Future<void> call() {
    return _repository.cancelAll();
  }
}
