import 'package:equatable/equatable.dart';
import '../../domain/entities/prayer_time_entity.dart';

enum PrayerStatus { initial, loading, loaded, error }

class PrayerState extends Equatable {
  final PrayerTimesEntity? prayerTimes;
  final PrayerStatus status;
  final String calculationMethod;
  final List<String> enabledPrayers;
  final String selectedAdhan;
  final bool autoAdhan;
  final DateTime? nextPrayer;
  final String? nextPrayerName;
  final Duration? countdown;
  final String? locationName;

  const PrayerState({
    this.prayerTimes,
    this.status = PrayerStatus.initial,
    this.calculationMethod = 'egyptian',
    this.enabledPrayers = const ['fajr', 'dhuhr', 'asr', 'maghrib', 'isha'],
    this.selectedAdhan = 'default',
    this.autoAdhan = true,
    this.nextPrayer,
    this.nextPrayerName,
    this.countdown,
    this.locationName,
  });

  factory PrayerState.initial() => const PrayerState();

  PrayerState copyWith({
    PrayerTimesEntity? prayerTimes,
    PrayerStatus? status,
    String? calculationMethod,
    List<String>? enabledPrayers,
    String? selectedAdhan,
    bool? autoAdhan,
    DateTime? nextPrayer,
    String? nextPrayerName,
    Duration? countdown,
    String? locationName,
  }) {
    return PrayerState(
      prayerTimes: prayerTimes ?? this.prayerTimes,
      status: status ?? this.status,
      calculationMethod: calculationMethod ?? this.calculationMethod,
      enabledPrayers: enabledPrayers ?? this.enabledPrayers,
      selectedAdhan: selectedAdhan ?? this.selectedAdhan,
      autoAdhan: autoAdhan ?? this.autoAdhan,
      nextPrayer: nextPrayer ?? this.nextPrayer,
      nextPrayerName: nextPrayerName ?? this.nextPrayerName,
      countdown: countdown ?? this.countdown,
      locationName: locationName ?? this.locationName,
    );
  }

  @override
  List<Object?> get props => [
        prayerTimes,
        status,
        calculationMethod,
        enabledPrayers,
        selectedAdhan,
        autoAdhan,
        nextPrayer,
        nextPrayerName,
        countdown,
        locationName,
      ];
}
