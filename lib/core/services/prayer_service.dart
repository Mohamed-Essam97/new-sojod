import 'package:adhan/adhan.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/app_constants.dart';
import '../../features/prayer/domain/entities/prayer_time_entity.dart';

/// Uses adhan package directly for prayer times and qibla.
class PrayerService {
  final SharedPreferences _prefs;

  PrayerService(this._prefs);

  static final Map<String, CalculationMethod> _calculationMethods = {
    'muslim_world_league': CalculationMethod.muslim_world_league,
    'egyptian': CalculationMethod.egyptian,
    'karachi': CalculationMethod.karachi,
    'umm_al_qura': CalculationMethod.umm_al_qura,
    'dubai': CalculationMethod.dubai,
    'qatar': CalculationMethod.qatar,
    'kuwait': CalculationMethod.kuwait,
    'moon_sighting_committee': CalculationMethod.moon_sighting_committee,
    'singapore': CalculationMethod.singapore,
    'north_america': CalculationMethod.north_america,
    'turkey': CalculationMethod.turkey,
    'tehran': CalculationMethod.tehran,
  };

  // --- Location ---
  Future<void> saveLocation(double lat, double lng, [String? name]) async {
    await _prefs.setDouble(AppConstants.keyLocationLat, lat);
    await _prefs.setDouble(AppConstants.keyLocationLng, lng);
    if (name != null) await _prefs.setString(AppConstants.keyLocationName, name);
  }

  Future<({double? lat, double? lng, String? name})> getLocation() async {
    return (
      lat: _prefs.getDouble(AppConstants.keyLocationLat),
      lng: _prefs.getDouble(AppConstants.keyLocationLng),
      name: _prefs.getString(AppConstants.keyLocationName),
    );
  }

  /// Device's local UTC offset for correct prayer times in user's timezone.
  Duration get _localUtcOffset => DateTime.now().timeZoneOffset;

  // --- Prayer times (adhan API) ---
  /// Returns prayer times for today in the device's local timezone.
  PrayerTimesEntity getPrayerTimes(double lat, double lng) {
    final coordinates = Coordinates(lat, lng);
    final methodKey = _prefs.getString(AppConstants.keyPrayerMethod) ?? 'karachi';
    final params = (_calculationMethods[methodKey] ?? CalculationMethod.karachi)
        .getParameters();
    params.madhab = Madhab.hanafi;

    final now = DateTime.now();
    final dateComponents = DateComponents.from(now);
    final prayerTimes = PrayerTimes(
      coordinates,
      dateComponents,
      params,
      utcOffset: _localUtcOffset,
    );

    return PrayerTimesEntity(
      fajr: prayerTimes.fajr,
      sunrise: prayerTimes.sunrise,
      dhuhr: prayerTimes.dhuhr,
      asr: prayerTimes.asr,
      maghrib: prayerTimes.maghrib,
      isha: prayerTimes.isha,
    );
  }

  /// Returns prayer times for a specific date in the device's local timezone.
  PrayerTimesEntity getPrayerTimesForDate(
    double lat,
    double lng,
    DateTime date, {
    Duration? utcOffset,
  }) {
    final coordinates = Coordinates(lat, lng);
    final dateComponents = DateComponents.from(date);
    final methodKey = _prefs.getString(AppConstants.keyPrayerMethod) ?? 'karachi';
    final params = (_calculationMethods[methodKey] ?? CalculationMethod.karachi)
        .getParameters();
    params.madhab = Madhab.hanafi;

    final offset = utcOffset ?? _localUtcOffset;
    final prayerTimes = PrayerTimes(
      coordinates,
      dateComponents,
      params,
      utcOffset: offset,
    );

    return PrayerTimesEntity(
      fajr: prayerTimes.fajr,
      sunrise: prayerTimes.sunrise,
      dhuhr: prayerTimes.dhuhr,
      asr: prayerTimes.asr,
      maghrib: prayerTimes.maghrib,
      isha: prayerTimes.isha,
    );
  }

  // --- Qibla (adhan API) ---
  double getQiblaDirection(double lat, double lng) {
    final coordinates = Coordinates(lat, lng);
    final qibla = Qibla(coordinates);
    return qibla.direction;
  }

  // --- Preferences ---
  String getCalculationMethod() =>
      _prefs.getString(AppConstants.keyPrayerMethod) ?? 'karachi';

  Future<void> setCalculationMethod(String method) async =>
      _prefs.setString(AppConstants.keyPrayerMethod, method);

  /// Upcoming prayers for the next 7 days (enabled prayers only).
  List<({String key, DateTime time, DateTime date})> getUpcomingPrayersNext7Days(
    double lat,
    double lng,
  ) {
    final enabled = getEnabledPrayers();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final result = <({String key, DateTime time, DateTime date})>[];

    for (var d = 0; d < 7; d++) {
      final date = today.add(Duration(days: d));
      final pt = getPrayerTimesForDate(lat, lng, date);
      final prayers = [
        if (enabled.contains('fajr')) (key: 'fajr', time: pt.fajr),
        if (enabled.contains('dhuhr')) (key: 'dhuhr', time: pt.dhuhr),
        if (enabled.contains('asr')) (key: 'asr', time: pt.asr),
        if (enabled.contains('maghrib')) (key: 'maghrib', time: pt.maghrib),
        if (enabled.contains('isha')) (key: 'isha', time: pt.isha),
      ];
      for (final p in prayers) {
        if (p.time.isAfter(now)) {
          result.add((key: p.key, time: p.time, date: date));
        }
      }
    }
    return result;
  }

  List<String> getEnabledPrayers() =>
      _prefs.getStringList(AppConstants.keyEnabledPrayers) ??
      ['fajr', 'dhuhr', 'asr', 'maghrib', 'isha'];

  Future<void> setEnabledPrayers(List<String> prayers) async =>
      _prefs.setStringList(AppConstants.keyEnabledPrayers, prayers);

  String getSelectedAdhan() =>
      _prefs.getString(AppConstants.keySelectedAdhan) ?? 'default';

  Future<void> setSelectedAdhan(String adhan) async =>
      _prefs.setString(AppConstants.keySelectedAdhan, adhan);

  bool getAutoAdhan() => _prefs.getBool(AppConstants.keyAutoAdhan) ?? true;

  Future<void> setAutoAdhan(bool value) async =>
      _prefs.setBool(AppConstants.keyAutoAdhan, value);

  List<String> get calculationMethodKeys => _calculationMethods.keys.toList();
}
