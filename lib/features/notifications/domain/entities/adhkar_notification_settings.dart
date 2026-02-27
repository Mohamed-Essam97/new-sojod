import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class AdhkarNotificationSettings extends Equatable {
  final bool morningEnabled;
  final TimeOfDay morningTime;
  final bool eveningEnabled;
  final TimeOfDay eveningTime;
  final bool sleepEnabled;
  final TimeOfDay sleepTime;

  const AdhkarNotificationSettings({
    this.morningEnabled = false,
    this.morningTime = const TimeOfDay(hour: 7, minute: 0),
    this.eveningEnabled = false,
    this.eveningTime = const TimeOfDay(hour: 17, minute: 0),
    this.sleepEnabled = false,
    this.sleepTime = const TimeOfDay(hour: 23, minute: 0),
  });

  AdhkarNotificationSettings copyWith({
    bool? morningEnabled,
    TimeOfDay? morningTime,
    bool? eveningEnabled,
    TimeOfDay? eveningTime,
    bool? sleepEnabled,
    TimeOfDay? sleepTime,
  }) {
    return AdhkarNotificationSettings(
      morningEnabled: morningEnabled ?? this.morningEnabled,
      morningTime: morningTime ?? this.morningTime,
      eveningEnabled: eveningEnabled ?? this.eveningEnabled,
      eveningTime: eveningTime ?? this.eveningTime,
      sleepEnabled: sleepEnabled ?? this.sleepEnabled,
      sleepTime: sleepTime ?? this.sleepTime,
    );
  }

  @override
  List<Object?> get props => [
        morningEnabled,
        morningTime.hour,
        morningTime.minute,
        eveningEnabled,
        eveningTime.hour,
        eveningTime.minute,
        sleepEnabled,
        sleepTime.hour,
        sleepTime.minute,
      ];
}
