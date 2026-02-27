import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class SettingsState extends Equatable {
  final ThemeMode themeMode;
  final Locale locale;
  final bool permissionsGranted;

  const SettingsState({
    required this.themeMode,
    required this.locale,
    required this.permissionsGranted,
  });

  SettingsState copyWith({
    ThemeMode? themeMode,
    Locale? locale,
    bool? permissionsGranted,
  }) {
    return SettingsState(
      themeMode: themeMode ?? this.themeMode,
      locale: locale ?? this.locale,
      permissionsGranted: permissionsGranted ?? this.permissionsGranted,
    );
  }

  @override
  List<Object?> get props => [themeMode, locale, permissionsGranted];
}
