import '../entities/reciter.dart';
import '../repositories/reciter_repository.dart';

class SetSelectedReciter {
  SetSelectedReciter(this._repository);

  final ReciterRepository _repository;

  Future<void> call(Reciter reciter) =>
      _repository.setSelectedReciter(reciter);
}
