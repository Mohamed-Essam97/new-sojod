import 'package:equatable/equatable.dart';

import '../../domain/entities/adhkar_notification_settings.dart';
import '../../domain/entities/prayer_notification_settings.dart';

class NotificationState extends Equatable {
  final PrayerNotificationSettings prayerSettings;
  final AdhkarNotificationSettings adhkarSettings;
  final bool permissionsGranted;
  final bool isLoading;

  const NotificationState({
    this.prayerSettings = const PrayerNotificationSettings(),
    this.adhkarSettings = const AdhkarNotificationSettings(),
    this.permissionsGranted = false,
    this.isLoading = false,
  });

  NotificationState copyWith({
    PrayerNotificationSettings? prayerSettings,
    AdhkarNotificationSettings? adhkarSettings,
    bool? permissionsGranted,
    bool? isLoading,
  }) {
    return NotificationState(
      prayerSettings: prayerSettings ?? this.prayerSettings,
      adhkarSettings: adhkarSettings ?? this.adhkarSettings,
      permissionsGranted: permissionsGranted ?? this.permissionsGranted,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props =>
      [prayerSettings, adhkarSettings, permissionsGranted, isLoading];
}
