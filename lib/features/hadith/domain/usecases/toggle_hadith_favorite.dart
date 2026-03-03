import '../repositories/hadith_repository.dart';

class ToggleHadithFavorite {
  const ToggleHadithFavorite(this._repository);
  final HadithRepository _repository;

  Future<Set<String>> call(String hadithId) =>
      _repository.toggleFavorite(hadithId);
}
