import '../entities/reciter.dart';
import '../repositories/reciter_repository.dart';

class GetSelectedReciter {
  GetSelectedReciter(this._repository);

  final ReciterRepository _repository;

  Reciter call() => _repository.getSelectedReciter();
}
