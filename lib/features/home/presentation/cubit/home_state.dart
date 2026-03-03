import 'package:equatable/equatable.dart';
import 'package:hijri/hijri_calendar.dart';

import '../../../prayer/domain/entities/prayer_time_entity.dart';

/// Represents a selected prayer for the hero card.
typedef PrayerSelection = ({String key, DateTime time, DateTime date});

class HomeState extends Equatable {
  final PrayerTimesEntity? prayerTimes;
  final DateTime? nextPrayer;
  final String? nextPrayerName;
  /// Date of the next prayer (for Jumu'ah display when next is tomorrow)
  final DateTime? nextPrayerDate;
  /// Upcoming prayers for the next 7 days (each has key, time, and date)
  final List<PrayerSelection> upcomingPrayers;
  /// User-selected prayer for hero card; null = show next prayer
  final PrayerSelection? selectedPrayer;
  final String locationName;
  final HijriCalendar? hijriDate;
  final int lastReadPage;

  const HomeState({
    this.prayerTimes,
    this.nextPrayer,
    this.nextPrayerName,
    this.nextPrayerDate,
    this.upcomingPrayers = const [],
    this.selectedPrayer,
    this.locationName = '',
    this.hijriDate,
    this.lastReadPage = 1,
  });

  /// Prayer to display in hero card: selected or next
  PrayerSelection? get displayedPrayer =>
      selectedPrayer ?? (upcomingPrayers.isNotEmpty ? upcomingPrayers.first : null);

  factory HomeState.initial() => const HomeState();

  static const _undefined = Object();

  HomeState copyWith({
    PrayerTimesEntity? prayerTimes,
    DateTime? nextPrayer,
    String? nextPrayerName,
    DateTime? nextPrayerDate,
    List<PrayerSelection>? upcomingPrayers,
    Object? selectedPrayer = _undefined,
    String? locationName,
    HijriCalendar? hijriDate,
    int? lastReadPage,
  }) {
    return HomeState(
      prayerTimes: prayerTimes ?? this.prayerTimes,
      nextPrayer: nextPrayer ?? this.nextPrayer,
      nextPrayerName: nextPrayerName ?? this.nextPrayerName,
      nextPrayerDate: nextPrayerDate ?? this.nextPrayerDate,
      upcomingPrayers: upcomingPrayers ?? this.upcomingPrayers,
      selectedPrayer: selectedPrayer == _undefined
          ? this.selectedPrayer
          : selectedPrayer as PrayerSelection?,
      locationName: locationName ?? this.locationName,
      hijriDate: hijriDate ?? this.hijriDate,
      lastReadPage: lastReadPage ?? this.lastReadPage,
    );
  }

  /// Countdown to the displayed prayer. Builds the target moment in local time
  /// from the prayer's date and time-of-day so it stays correct when adhan
  /// returns UTC-with-offset (local clock stored as UTC).
  Duration? get countdown {
    final selection = displayedPrayer;
    if (selection == null) return null;
    final date = selection.date;
    final t = selection.time;
    final now = DateTime.now();
    final localPrayerMoment = DateTime(
      date.year,
      date.month,
      date.day,
      t.hour,
      t.minute,
      t.second,
    );
    final d = localPrayerMoment.difference(now);
    return d.isNegative ? null : d;
  }

  @override
  List<Object?> get props => [
        prayerTimes,
        nextPrayer,
        nextPrayerName,
        nextPrayerDate,
        upcomingPrayers,
        selectedPrayer,
        locationName,
        hijriDate,
        lastReadPage,
      ];
}
