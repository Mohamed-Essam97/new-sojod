import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hijri/hijri_calendar.dart';

import '../../domain/repositories/hijri_repository.dart';

import 'hijri_state.dart';

class HijriCubit extends Cubit<HijriState> {
  final HijriRepository _repository;

  HijriCubit(this._repository) : super(HijriState.initial()) {
    loadHijriDate();
  }

  Future<void> loadHijriDate() async {
    final adjustment = await _repository.getAdjustment();
    final gregorian = DateTime.now().add(Duration(days: adjustment));
    final hijri = HijriCalendar.fromDate(gregorian);
    emit(state.copyWith(
      hijriDate: hijri,
      gregorianDate: DateTime.now(),
      adjustment: adjustment,
    ));
  }

  Future<void> setAdjustment(int days) async {
    await _repository.setAdjustment(days);
    await loadHijriDate();
  }
}
