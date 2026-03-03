import 'package:hive_flutter/hive_flutter.dart';

import '../datasources/hadith_local_datasource.dart';
import '../utils/arabic_normalizer.dart';
import '../../domain/entities/chapter_entity.dart';
import '../../domain/entities/collection_entity.dart';
import '../../domain/entities/hadith_entity.dart';
import '../../domain/repositories/hadith_repository.dart';

class HadithRepositoryImpl implements HadithRepository {
  HadithRepositoryImpl({
    required HadithLocalDatasource datasource,
    required Box favoritesBox,
  })  : _datasource = datasource,
        _favoritesBox = favoritesBox;

  final HadithLocalDatasource _datasource;
  final Box _favoritesBox;

  static const String _favoritesKey = 'hadith_favorite_ids';

  List<CollectionEntity>? _entities;

  @override
  Future<void> ensureLoaded() async {
    await _datasource.loadCollections();
    _entities ??= (_datasource.collections ?? []).map((m) => m.toEntity()).toList();
  }

  List<CollectionEntity> _getEntities() {
    final models = _datasource.collections;
    if (models == null) return [];
    _entities ??= models.map((m) => m.toEntity()).toList();
    return _entities!;
  }

  @override
  List<CollectionEntity> getCollections() {
    return _getEntities();
  }

  @override
  CollectionEntity? getCollection(String collectionId) {
    final list = _getEntities();
    try {
      return list.firstWhere((c) => c.id == collectionId);
    } catch (_) {
      return null;
    }
  }

  @override
  List<ChapterEntity> getChapters(String collectionId) {
    final c = getCollection(collectionId);
    return c?.chapters ?? [];
  }

  @override
  HadithEntity? getHadithById(String hadithId) {
    for (final col in _getEntities()) {
      for (final ch in col.chapters) {
        for (final h in ch.hadiths) {
          if (h.id == hadithId) return h;
        }
      }
    }
    return null;
  }

  @override
  List<HadithEntity> searchHadiths(String query) {
    if (query.trim().isEmpty) return [];
    final normalizedQuery = normalizeArabic(query.trim());
    if (normalizedQuery.isEmpty) return [];
    final results = <HadithEntity>[];
    for (final col in _getEntities()) {
      for (final ch in col.chapters) {
        for (final h in ch.hadiths) {
          final normalizedArabic = normalizeArabic(h.arabic);
          final normalizedRef = normalizeArabic(h.referenceAr);
          if (normalizedArabic.contains(normalizedQuery) ||
              normalizedRef.contains(normalizedQuery)) {
            results.add(h);
          }
        }
      }
    }
    return results;
  }

  Set<String> _getFavoriteIdsSet() {
    final raw = _favoritesBox.get(_favoritesKey);
    if (raw == null || raw is! String) return {};
    final s = raw;
    if (s.isEmpty) return {};
    return s.split(',').where((e) => e.isNotEmpty).toSet();
  }

  Future<void> _saveFavoriteIds(Set<String> ids) async {
    await _favoritesBox.put(_favoritesKey, ids.join(','));
  }

  @override
  Future<Set<String>> getFavoriteIds() async {
    return _getFavoriteIdsSet();
  }

  @override
  Future<Set<String>> toggleFavorite(String hadithId) async {
    final set = _getFavoriteIdsSet();
    if (set.contains(hadithId)) {
      set.remove(hadithId);
    } else {
      set.add(hadithId);
    }
    await _saveFavoriteIds(set);
    return set;
  }

  @override
  Future<bool> isFavorite(String hadithId) async {
    return _getFavoriteIdsSet().contains(hadithId);
  }
}
