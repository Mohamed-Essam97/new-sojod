import '../entities/chapter_entity.dart';
import '../entities/collection_entity.dart';
import '../entities/hadith_entity.dart';

abstract class HadithRepository {
  /// Load asset data. Call once before using getCollections/getChapters/search.
  Future<void> ensureLoaded();

  /// All collections (with chapters and hadiths). Call after ensureLoaded().
  List<CollectionEntity> getCollections();

  /// Get a single collection by id.
  CollectionEntity? getCollection(String collectionId);

  /// Get chapters of a collection.
  List<ChapterEntity> getChapters(String collectionId);

  /// Get a single hadith by id (e.g. "riyad_1_1").
  HadithEntity? getHadithById(String hadithId);

  /// Search hadiths by Arabic text (normalized). Returns hadiths matching query.
  List<HadithEntity> searchHadiths(String query);

  /// Favorite IDs (hadith id list).
  Future<Set<String>> getFavoriteIds();

  /// Toggle favorite; returns new favorite set.
  Future<Set<String>> toggleFavorite(String hadithId);

  /// Check if a hadith is favorited.
  Future<bool> isFavorite(String hadithId);
}
