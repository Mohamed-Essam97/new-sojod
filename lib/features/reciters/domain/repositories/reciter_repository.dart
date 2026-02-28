import '../entities/reciter.dart';

abstract class ReciterRepository {
  List<Reciter> getAllReciters();
  Reciter getSelectedReciter();
  Future<void> setSelectedReciter(Reciter reciter);
}
