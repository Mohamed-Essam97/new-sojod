import '../entities/wird_entity.dart';
import '../repositories/wird_repository.dart';

class UpdateWirdProgress {
  UpdateWirdProgress(this._repository);

  final WirdRepository _repository;

  Future<void> call(String userId, WirdEntity wird) => 
      _repository.updateWirdProgress(userId, wird);
}
