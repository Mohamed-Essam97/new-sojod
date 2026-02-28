import '../entities/reciter.dart';
import '../repositories/reciter_repository.dart';

class GetAllReciters {
  GetAllReciters(this._repository);

  final ReciterRepository _repository;

  List<Reciter> call() => _repository.getAllReciters();
}
