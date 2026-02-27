import 'package:flutter/material.dart';
import 'package:quran_with_tafsir/quran_with_tafsir.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constants/app_constants.dart';
import '../../domain/repositories/settings_repository.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final SharedPreferences sharedPreferences;

  SettingsRepositoryImpl({required this.sharedPreferences});

  @override
  ThemeMode getThemeMode() {
    final value = sharedPreferences.getString(AppConstants.keyThemeMode);
    if (value == null) return ThemeMode.system;
    return ThemeMode.values.firstWhere(
      (e) => e.name == value,
      orElse: () => ThemeMode.system,
    );
  }

  @override
  Future<void> setThemeMode(ThemeMode mode) async {
    await sharedPreferences.setString(AppConstants.keyThemeMode, mode.name);
  }

  @override
  Locale getLocale() {
    final code = sharedPreferences.getString(AppConstants.keyLocale);
    if (code == null) return const Locale('en');
    return Locale(code);
  }

  @override
  Future<void> setLocale(Locale locale) async {
    await sharedPreferences.setString(AppConstants.keyLocale, locale.languageCode);
  }

  @override
  bool getPermissionsGranted() {
    return sharedPreferences.getBool(AppConstants.keyPermissionsGranted) ?? false;
  }

  @override
  Future<void> setPermissionsGranted(bool value) async {
    await sharedPreferences.setBool(AppConstants.keyPermissionsGranted, value);
  }

  @override
  String getSelectedReciter() =>
      sharedPreferences.getString(AppConstants.keyQuranReciter) ??
      Reciters.alafasy;

  @override
  Future<void> setSelectedReciter(String reciter) async {
    await sharedPreferences.setString(AppConstants.keyQuranReciter, reciter);
  }
}
