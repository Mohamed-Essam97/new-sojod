import '../entities/hadith_entity.dart';
import '../repositories/hadith_repository.dart';

class GetHadithById {
  const GetHadithById(this._repository);
  final HadithRepository _repository;

  HadithEntity? call(String hadithId) => _repository.getHadithById(hadithId);
}
