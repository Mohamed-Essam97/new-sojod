import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class SettingsState extends Equatable {
  final ThemeMode themeMode;
  final Locale locale;
  final bool permissionsGranted;
  final String selectedReciter;

  const SettingsState({
    required this.themeMode,
    required this.locale,
    required this.permissionsGranted,
    this.selectedReciter = 'Alafasy_128kbps',
  });

  SettingsState copyWith({
    ThemeMode? themeMode,
    Locale? locale,
    bool? permissionsGranted,
    String? selectedReciter,
  }) {
    return SettingsState(
      themeMode: themeMode ?? this.themeMode,
      locale: locale ?? this.locale,
      permissionsGranted: permissionsGranted ?? this.permissionsGranted,
      selectedReciter: selectedReciter ?? this.selectedReciter,
    );
  }

  @override
  List<Object?> get props => [themeMode, locale, permissionsGranted, selectedReciter];
}
