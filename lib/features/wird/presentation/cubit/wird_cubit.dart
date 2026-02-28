import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/wird_entity.dart';
import '../../domain/usecases/get_today_wird.dart';
import '../../domain/usecases/save_wird.dart';
import '../../domain/usecases/update_wird_progress.dart';
import '../../domain/usecases/watch_today_wird.dart';
import 'wird_state.dart';

class WirdCubit extends Cubit<WirdState> {
  WirdCubit({
    required GetTodayWird getTodayWird,
    required SaveWird saveWird,
    required UpdateWirdProgress updateWirdProgress,
    required WatchTodayWird watchTodayWird,
  })  : _getTodayWird = getTodayWird,
        _saveWird = saveWird,
        _updateWirdProgress = updateWirdProgress,
        _watchTodayWird = watchTodayWird,
        super(const WirdInitial());

  final GetTodayWird _getTodayWird;
  final SaveWird _saveWird;
  final UpdateWirdProgress _updateWirdProgress;
  final WatchTodayWird _watchTodayWird;

  StreamSubscription<WirdEntity?>? _wirdSubscription;
  String? _currentUserId;

  Future<void> loadTodayWird(String userId) async {
    emit(const WirdLoading());
    _currentUserId = userId;

    try {
      final wird = await _getTodayWird(userId);
      if (wird != null) {
        emit(WirdLoaded(wird));
      } else {
        emit(const WirdEmpty());
      }
    } catch (e) {
      emit(WirdError(e.toString()));
    }
  }

  void watchTodayWirdUpdates(String userId) {
    _currentUserId = userId;
    _wirdSubscription?.cancel();
    
    _wirdSubscription = _watchTodayWird(userId).listen((wird) {
      if (wird != null) {
        emit(WirdLoaded(wird));
      } else {
        emit(const WirdEmpty());
      }
    });
  }

  Future<void> createWird({
    required String userId,
    int quranTargetPages = 0,
    int tasbeehTarget = 0,
  }) async {
    try {
      final wird = WirdEntity(
        date: DateTime.now(),
        quranTargetPages: quranTargetPages,
        tasbeehTarget: tasbeehTarget,
      );

      await _saveWird(userId, wird);
      emit(WirdLoaded(wird));
    } catch (e) {
      emit(WirdError(e.toString()));
    }
  }

  Future<void> updateQuranProgress(int pages) async {
    if (state is! WirdLoaded || _currentUserId == null) return;

    final currentWird = (state as WirdLoaded).wird;
    final updatedWird = currentWird.copyWith(
      quranProgressPages: pages.clamp(0, currentWird.quranTargetPages),
    );

    try {
      await _updateWirdProgress(_currentUserId!, updatedWird);
      emit(WirdLoaded(updatedWird));
    } catch (e) {
      emit(WirdError(e.toString()));
    }
  }

  Future<void> toggleAdhkarMorning() async {
    if (state is! WirdLoaded || _currentUserId == null) return;

    final currentWird = (state as WirdLoaded).wird;
    final updatedWird = currentWird.copyWith(
      adhkarMorningDone: !currentWird.adhkarMorningDone,
    );

    try {
      await _updateWirdProgress(_currentUserId!, updatedWird);
      emit(WirdLoaded(updatedWird));
    } catch (e) {
      emit(WirdError(e.toString()));
    }
  }

  Future<void> toggleAdhkarEvening() async {
    if (state is! WirdLoaded || _currentUserId == null) return;

    final currentWird = (state as WirdLoaded).wird;
    final updatedWird = currentWird.copyWith(
      adhkarEveningDone: !currentWird.adhkarEveningDone,
    );

    try {
      await _updateWirdProgress(_currentUserId!, updatedWird);
      emit(WirdLoaded(updatedWird));
    } catch (e) {
      emit(WirdError(e.toString()));
    }
  }

  Future<void> toggleSleepDhikr() async {
    if (state is! WirdLoaded || _currentUserId == null) return;

    final currentWird = (state as WirdLoaded).wird;
    final updatedWird = currentWird.copyWith(
      sleepDhikrDone: !currentWird.sleepDhikrDone,
    );

    try {
      await _updateWirdProgress(_currentUserId!, updatedWird);
      emit(WirdLoaded(updatedWird));
    } catch (e) {
      emit(WirdError(e.toString()));
    }
  }

  Future<void> updateTasbeehProgress(int count) async {
    if (state is! WirdLoaded || _currentUserId == null) return;

    final currentWird = (state as WirdLoaded).wird;
    final updatedWird = currentWird.copyWith(
      tasbeehProgress: count.clamp(0, currentWird.tasbeehTarget),
    );

    try {
      await _updateWirdProgress(_currentUserId!, updatedWird);
      emit(WirdLoaded(updatedWird));
    } catch (e) {
      emit(WirdError(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _wirdSubscription?.cancel();
    return super.close();
  }
}
