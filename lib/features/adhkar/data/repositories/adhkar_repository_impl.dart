import 'package:hive_flutter/hive_flutter.dart';

import '../adhkar_data.dart';
import '../../domain/entities/adhkar_category_entity.dart';
import '../../domain/repositories/adhkar_repository.dart';

class AdhkarRepositoryImpl implements AdhkarRepository {
  final Box box;

  AdhkarRepositoryImpl({required this.box});

  @override
  List<AdhkarCategoryEntity> getCategories() => getAdhkarData();

  @override
  Future<Map<String, int>> getProgress(String categoryId) async {
    final key = 'progress_$categoryId';
    final data = box.get(key);
    if (data is Map) {
      return Map<String, int>.from(data);
    }
    return {};
  }

  @override
  Future<void> setProgress(String categoryId, String dhikrKey, int count) async {
    final key = 'progress_$categoryId';
    final raw = box.get(key);
    final data = raw is Map ? Map<String, int>.from(raw.map((k, v) => MapEntry(k.toString(), v is int ? v : 0))) : <String, int>{};
    data[dhikrKey] = count;
    await box.put(key, data);
  }

  @override
  Future<int> getCompletedCount(String categoryId) async {
    final categories = getCategories();
    final category = categories.firstWhere(
      (c) => c.id == categoryId,
      orElse: () => categories.first,
    );
    final progress = await getProgress(categoryId);
    int completed = 0;
    for (var i = 0; i < category.dhikrs.length; i++) {
      final dhikr = category.dhikrs[i];
      final key = '${i}_${dhikr.arabic.hashCode}';
      final current = progress[key] ?? 0;
      if (current >= dhikr.count) completed++;
    }
    return completed;
  }
}
