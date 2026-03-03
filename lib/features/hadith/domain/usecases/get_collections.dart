import '../entities/collection_entity.dart';
import '../repositories/hadith_repository.dart';

class GetCollections {
  const GetCollections(this._repository);
  final HadithRepository _repository;

  List<CollectionEntity> call() => _repository.getCollections();
}
