import '../entities/chapter_entity.dart';
import '../repositories/hadith_repository.dart';

class GetChapters {
  const GetChapters(this._repository);
  final HadithRepository _repository;

  List<ChapterEntity> call(String collectionId) =>
      _repository.getChapters(collectionId);
}
