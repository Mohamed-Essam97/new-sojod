import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import '../../../../core/services/prayer_service.dart';

import 'prayer_state.dart';

class PrayerCubit extends Cubit<PrayerState> {
  final PrayerService _service;
  Timer? _countdownTimer;

  PrayerCubit(this._service) : super(PrayerState.initial()) {
    _loadPrayerSettings();
    loadPrayerTimes();
    _startCountdownTimer();
  }

  void _loadPrayerSettings() {
    emit(state.copyWith(
      calculationMethod: _service.getCalculationMethod(),
      enabledPrayers: _service.getEnabledPrayers(),
      selectedAdhan: _service.getSelectedAdhan(),
      autoAdhan: _service.getAutoAdhan(),
    ));
  }

  Future<void> loadPrayerTimes() async {
    emit(state.copyWith(status: PrayerStatus.loading));

    var loc = await _service.getLocation();
    double? lat = loc.lat;
    double? lng = loc.lng;

    if (lat == null || lng == null) {
      try {
        final pos = await Geolocator.getCurrentPosition();
        lat = pos.latitude;
        lng = pos.longitude;
        String? name;
        try {
          final placemarks = await placemarkFromCoordinates(lat, lng);
          if (placemarks.isNotEmpty) {
            final p = placemarks.first;
            name = [p.locality, p.administrativeArea]
                .whereType<String>()
                .where((s) => s.isNotEmpty)
                .join(', ');
            if (name.isEmpty) name = p.country;
          }
        } catch (_) {}
        await _service.saveLocation(lat, lng, name);
        loc = await _service.getLocation();
      } catch (_) {
        emit(state.copyWith(status: PrayerStatus.error));
        return;
      }
    }

    final times = _service.getPrayerTimes(lat, lng);
    final next = times.getNextPrayer(state.enabledPrayers);
    emit(state.copyWith(
      prayerTimes: times,
      status: PrayerStatus.loaded,
      nextPrayer: next,
      nextPrayerName: times.getNextPrayerName(state.enabledPrayers),
      locationName: loc.name,
    ));
  }

  void _startCountdownTimer() {
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (state.prayerTimes != null && state.nextPrayer != null) {
        final remaining = state.nextPrayer!.difference(DateTime.now());
        if (remaining.isNegative) {
          loadPrayerTimes();
        } else {
          emit(state.copyWith(countdown: remaining));
        }
      }
    });
  }

  Future<void> setCalculationMethod(String method) async {
    await _service.setCalculationMethod(method);
    emit(state.copyWith(calculationMethod: method));
    await loadPrayerTimes();
  }

  Future<void> setEnabledPrayers(List<String> prayers) async {
    await _service.setEnabledPrayers(prayers);
    emit(state.copyWith(enabledPrayers: prayers));
    if (state.prayerTimes != null) {
      final next = state.prayerTimes!.getNextPrayer(prayers);
      emit(state.copyWith(
        nextPrayer: next,
        nextPrayerName: state.prayerTimes!.getNextPrayerName(prayers),
      ));
    }
  }

  Future<void> setSelectedAdhan(String adhan) async {
    await _service.setSelectedAdhan(adhan);
    emit(state.copyWith(selectedAdhan: adhan));
  }

  Future<void> setAutoAdhan(bool value) async {
    await _service.setAutoAdhan(value);
    emit(state.copyWith(autoAdhan: value));
  }

  @override
  Future<void> close() {
    _countdownTimer?.cancel();
    return super.close();
  }
}
