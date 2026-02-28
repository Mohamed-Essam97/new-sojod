import '../entities/wird_entity.dart';
import '../repositories/wird_repository.dart';

class GetTodayWird {
  GetTodayWird(this._repository);

  final WirdRepository _repository;

  Future<WirdEntity?> call(String userId) => _repository.getTodayWird(userId);
}
