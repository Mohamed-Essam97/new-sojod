import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/repositories/settings_repository.dart';
import 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final SettingsRepository _repository;

  SettingsCubit(this._repository)
      : super(SettingsState(
          themeMode: _repository.getThemeMode(),
          locale: _repository.getLocale(),
          permissionsGranted: _repository.getPermissionsGranted(),
        ));

  void setThemeMode(ThemeMode mode) async {
    await _repository.setThemeMode(mode);
    emit(state.copyWith(themeMode: mode));
  }

  void setLocale(Locale locale) async {
    await _repository.setLocale(locale);
    emit(state.copyWith(locale: locale));
  }

  void setPermissionsGranted(bool value) async {
    await _repository.setPermissionsGranted(value);
    emit(state.copyWith(permissionsGranted: value));
  }

  void loadSettings() {
    emit(SettingsState(
      themeMode: _repository.getThemeMode(),
      locale: _repository.getLocale(),
      permissionsGranted: _repository.getPermissionsGranted(),
    ));
  }
}
