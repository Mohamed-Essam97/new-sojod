import 'package:equatable/equatable.dart';

class PrayerTimesEntity extends Equatable {
  final DateTime fajr;
  final DateTime sunrise;
  final DateTime dhuhr;
  final DateTime asr;
  final DateTime maghrib;
  final DateTime isha;

  const PrayerTimesEntity({
    required this.fajr,
    required this.sunrise,
    required this.dhuhr,
    required this.asr,
    required this.maghrib,
    required this.isha,
  });

  DateTime? getNextPrayer(List<String> enabled) {
    final now = DateTime.now();
    final prayers = [
      if (enabled.contains('fajr')) ('fajr', fajr),
      if (enabled.contains('dhuhr')) ('dhuhr', dhuhr),
      if (enabled.contains('asr')) ('asr', asr),
      if (enabled.contains('maghrib')) ('maghrib', maghrib),
      if (enabled.contains('isha')) ('isha', isha),
    ];
    for (final p in prayers) {
      if (p.$2.isAfter(now)) return p.$2;
    }
    return null;
  }

  String? getNextPrayerName(List<String> enabled) {
    final now = DateTime.now();
    final prayers = [
      if (enabled.contains('fajr')) ('fajr', fajr),
      if (enabled.contains('dhuhr')) ('dhuhr', dhuhr),
      if (enabled.contains('asr')) ('asr', asr),
      if (enabled.contains('maghrib')) ('maghrib', maghrib),
      if (enabled.contains('isha')) ('isha', isha),
    ];
    for (final p in prayers) {
      if (p.$2.isAfter(now)) return p.$1;
    }
    return 'fajr';
  }

  /// All prayers from now onwards for today (for upcoming list)
  List<({String key, DateTime time})> getUpcomingPrayersToday() {
    final now = DateTime.now();
    final all = [
      (key: 'fajr', time: fajr),
      (key: 'sunrise', time: sunrise),
      (key: 'dhuhr', time: dhuhr),
      (key: 'asr', time: asr),
      (key: 'maghrib', time: maghrib),
      (key: 'isha', time: isha),
    ];
    return all.where((p) => p.time.isAfter(now)).toList();
  }

  @override
  List<Object?> get props => [fajr, sunrise, dhuhr, asr, maghrib, isha];
}
