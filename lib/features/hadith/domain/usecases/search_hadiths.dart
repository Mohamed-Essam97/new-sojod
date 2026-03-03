import '../entities/hadith_entity.dart';
import '../repositories/hadith_repository.dart';

class SearchHadiths {
  const SearchHadiths(this._repository);
  final HadithRepository _repository;

  List<HadithEntity> call(String query) => _repository.searchHadiths(query);
}
