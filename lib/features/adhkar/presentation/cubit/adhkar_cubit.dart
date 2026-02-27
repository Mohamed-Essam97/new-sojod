import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/adhkar_category_entity.dart';
import '../../domain/repositories/adhkar_repository.dart';

import 'adhkar_state.dart';

class AdhkarCubit extends Cubit<AdhkarState> {
  final AdhkarRepository _repository;

  AdhkarCubit(this._repository) : super(AdhkarState.initial()) {
    loadCategories();
  }

  void loadCategories() {
    final categories = _repository.getCategories();
    emit(state.copyWith(categories: categories));
    for (final c in categories) {
      _loadProgress(c.id);
    }
  }

  Future<void> _loadProgress(String categoryId) async {
    final completed = await _repository.getCompletedCount(categoryId);
    final progress = await _repository.getProgress(categoryId);
    emit(state.copyWith(
      progressMap: {...state.progressMap, categoryId: progress},
      completedMap: {...state.completedMap, categoryId: completed},
    ));
  }

  Future<void> incrementDhikr(String categoryId, String dhikrKey, int targetCount) async {
    final progress = await _repository.getProgress(categoryId);
    final current = progress[dhikrKey] ?? 0;
    final newCount = (current + 1).clamp(0, targetCount);
    await _repository.setProgress(categoryId, dhikrKey, newCount);
    await _loadProgress(categoryId);
  }

  Future<void> resetDhikr(String categoryId, String dhikrKey) async {
    await _repository.setProgress(categoryId, dhikrKey, 0);
    await _loadProgress(categoryId);
  }
}
