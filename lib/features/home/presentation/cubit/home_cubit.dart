import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hijri/hijri_calendar.dart';

import '../../../../core/services/prayer_service.dart';
import '../../../settings/domain/repositories/settings_repository.dart';
import '../../../hijri/domain/repositories/hijri_repository.dart';
import '../../../quran/domain/repositories/quran_repository.dart';

import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final PrayerService _prayerService;
  final HijriRepository _hijriRepository;
  final QuranRepository _quranRepository;
  Timer? _timer;
  bool _isLoading = false;

  HomeCubit(
    this._prayerService,
    SettingsRepository _,
    this._hijriRepository,
    this._quranRepository,
  ) : super(HomeState.initial()) {
    load();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => load());
  }

  Future<void> load() async {
    if (_isLoading) return;
    _isLoading = true;
    try {
      await _loadInternal();
    } finally {
      _isLoading = false;
    }
  }

  Future<void> _loadInternal() async {
    var loc = await _prayerService.getLocation();
    var lat = loc.lat;
    var lng = loc.lng;

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
        await _prayerService.saveLocation(lat, lng, name);
        loc = await _prayerService.getLocation();
      } catch (_) {
        final adjustment = await _hijriRepository.getAdjustment();
        final gregorian = DateTime.now().add(Duration(days: adjustment));
        final hijri = HijriCalendar.fromDate(gregorian);
        emit(HomeState(
          locationName: 'Enable location for prayer times',
          hijriDate: hijri,
          lastReadPage: _quranRepository.getLastReadPage(),
        ));
        return;
      }
    }

    final prayerTimes = _prayerService.getPrayerTimes(lat, lng);

    final adjustment = await _hijriRepository.getAdjustment();
    final gregorian = DateTime.now().add(Duration(days: adjustment));
    final hijri = HijriCalendar.fromDate(gregorian);
    final lastPage = _quranRepository.getLastReadPage();
    final upcoming =
        _prayerService.getUpcomingPrayersNext7Days(lat, lng);

    // Next prayer = first in 7-day list (even if tomorrow)
    final nextPrayer = upcoming.isNotEmpty ? upcoming.first.time : null;
    final nextPrayerName = upcoming.isNotEmpty ? upcoming.first.key : null;
    final nextPrayerDate = upcoming.isNotEmpty ? upcoming.first.date : null;

    emit(HomeState(
      prayerTimes: prayerTimes,
      nextPrayer: nextPrayer,
      nextPrayerName: nextPrayerName,
      nextPrayerDate: nextPrayerDate,
      upcomingPrayers: upcoming,
      locationName: loc.name?.isNotEmpty == true ? loc.name! : 'Current location',
      hijriDate: hijri,
      lastReadPage: lastPage,
    ));
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
