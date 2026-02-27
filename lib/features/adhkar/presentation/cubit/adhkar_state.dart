import 'package:equatable/equatable.dart';
import '../../domain/entities/adhkar_category_entity.dart';

class AdhkarState extends Equatable {
  final List<AdhkarCategoryEntity> categories;
  final Map<String, Map<String, int>> progressMap;
  final Map<String, int> completedMap;

  const AdhkarState({
    this.categories = const [],
    this.progressMap = const {},
    this.completedMap = const {},
  });

  factory AdhkarState.initial() => const AdhkarState();

  AdhkarState copyWith({
    List<AdhkarCategoryEntity>? categories,
    Map<String, Map<String, int>>? progressMap,
    Map<String, int>? completedMap,
  }) {
    return AdhkarState(
      categories: categories ?? this.categories,
      progressMap: progressMap ?? this.progressMap,
      completedMap: completedMap ?? this.completedMap,
    );
  }

  int getCompleted(String categoryId) => completedMap[categoryId] ?? 0;
  int getTotal(String categoryId) {
    try {
      final cat = categories.firstWhere((c) => c.id == categoryId);
      return cat.dhikrs.length;
    } catch (_) {
      return 0;
    }
  }

  @override
  List<Object?> get props => [categories, progressMap, completedMap];
}
