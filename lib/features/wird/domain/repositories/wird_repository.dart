import '../entities/wird_entity.dart';

abstract class WirdRepository {
  Future<WirdEntity?> getTodayWird(String userId);
  Future<WirdEntity?> getWirdByDate(String userId, DateTime date);
  Future<void> saveWird(String userId, WirdEntity wird);
  Future<void> updateWirdProgress(String userId, WirdEntity wird);
  Stream<WirdEntity?> watchTodayWird(String userId);
  Future<List<WirdEntity>> getWirdHistory(String userId, {int days = 7});
}
