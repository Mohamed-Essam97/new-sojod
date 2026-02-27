import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/services/prayer_service.dart';
import '../../../../features/prayer/domain/entities/prayer_time_entity.dart';
import '../../domain/entities/adhkar_notification_settings.dart';
import '../../domain/entities/prayer_notification_settings.dart';
import '../../domain/repositories/notification_repository.dart';
import 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  final NotificationRepository _repository;
  final PrayerService _prayerService;

  NotificationCubit(this._repository, this._prayerService)
      : super(const NotificationState());

  Future<void> init() async {
    emit(state.copyWith(isLoading: true));
    try {
      final prayer = await _repository.getPrayerSettings();
      final adhkar = await _repository.getAdhkarSettings();
      final granted = await _repository.requestPermissions();

      emit(state.copyWith(
        prayerSettings: prayer,
        adhkarSettings: adhkar,
        permissionsGranted: granted,
        isLoading: false,
      ));

      if (granted) {
        await _rescheduleAll();
      }
    } catch (_) {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> _rescheduleAll() async {
    try {
      final loc = await _prayerService.getLocation();
      if (loc.lat == null || loc.lng == null) return;

      final timesForDays = <PrayerTimesEntity>[];
      for (var d = 0; d < 7; d++) {
        final date = DateTime.now().add(Duration(days: d));
        final times = _prayerService.getPrayerTimesForDate(
          loc.lat!,
          loc.lng!,
          date,
        );
        timesForDays.add(times);
      }

      await _repository.schedulePrayerNotifications(
        timesForDays,
        state.prayerSettings,
      );
      await _repository.scheduleAdhkarNotifications(state.adhkarSettings);
    } catch (_) {
      // Ignore scheduling errors
    }
  }

  Future<void> setPrayerSettings(PrayerNotificationSettings settings) async {
    await _repository.savePrayerSettings(settings);
    emit(state.copyWith(prayerSettings: settings));
    if (state.permissionsGranted) {
      await _rescheduleAll();
    }
  }

  Future<void> setAdhkarSettings(AdhkarNotificationSettings settings) async {
    await _repository.saveAdhkarSettings(settings);
    emit(state.copyWith(adhkarSettings: settings));
    if (state.permissionsGranted) {
      await _repository.scheduleAdhkarNotifications(settings);
    }
  }

  Future<bool> requestPermissions() async {
    final granted = await _repository.requestPermissions();
    emit(state.copyWith(permissionsGranted: granted));
    if (granted) {
      await _rescheduleAll();
    }
    return granted;
  }
}
