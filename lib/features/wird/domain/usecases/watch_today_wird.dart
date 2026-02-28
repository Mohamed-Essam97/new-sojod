import '../entities/wird_entity.dart';
import '../repositories/wird_repository.dart';

class WatchTodayWird {
  WatchTodayWird(this._repository);

  final WirdRepository _repository;

  Stream<WirdEntity?> call(String userId) => _repository.watchTodayWird(userId);
}
