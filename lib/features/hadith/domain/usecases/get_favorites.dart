import '../repositories/hadith_repository.dart';

class GetFavorites {
  const GetFavorites(this._repository);
  final HadithRepository _repository;

  Future<Set<String>> call() => _repository.getFavoriteIds();
}
