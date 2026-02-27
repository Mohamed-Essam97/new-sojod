import '../entities/adhkar_category_entity.dart';

abstract class AdhkarRepository {
  List<AdhkarCategoryEntity> getCategories();
  Future<Map<String, int>> getProgress(String categoryId);
  Future<void> setProgress(String categoryId, String dhikrKey, int count);
  Future<int> getCompletedCount(String categoryId);
}
