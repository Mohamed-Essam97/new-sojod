import 'package:equatable/equatable.dart';
import 'package:hijri/hijri_calendar.dart';

import '../../../prayer/domain/entities/prayer_time_entity.dart';

class HomeState extends Equatable {
  final PrayerTimesEntity? prayerTimes;
  final DateTime? nextPrayer;
  final String? nextPrayerName;
  final List<({String key, DateTime time})> upcomingPrayers;
  final String locationName;
  final HijriCalendar? hijriDate;
  final int lastReadPage;

  const HomeState({
    this.prayerTimes,
    this.nextPrayer,
    this.nextPrayerName,
    this.upcomingPrayers = const [],
    this.locationName = '',
    this.hijriDate,
    this.lastReadPage = 1,
  });

  factory HomeState.initial() => const HomeState();

  Duration? get countdown {
    if (nextPrayer == null) return null;
    final d = nextPrayer!.difference(DateTime.now());
    return d.isNegative ? null : d;
  }

  @override
  List<Object?> get props => [
        prayerTimes,
        nextPrayer,
        nextPrayerName,
        upcomingPrayers,
        locationName,
        hijriDate,
        lastReadPage,
      ];
}
