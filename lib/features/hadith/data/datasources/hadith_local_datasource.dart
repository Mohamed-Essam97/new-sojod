import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/collection_model.dart';

class HadithLocalDatasource {
  static const String _assetPath = 'assets/hadith/hadith_collections.json';

  List<CollectionModel>? _cached;

  /// Load and parse collections from asset. Cached after first load.
  Future<List<CollectionModel>> loadCollections() async {
    if (_cached != null) return _cached!;
    final jsonStr = await rootBundle.loadString(_assetPath);
    final map = json.decode(jsonStr) as Map<String, dynamic>;
    final list = map['collections'] as List<dynamic>? ?? [];
    _cached = list
        .map((e) => CollectionModel.fromJson(e as Map<String, dynamic>))
        .toList();
    return _cached!;
  }

  /// Synchronous get (after [loadCollections] has been called). Used by repo.
  List<CollectionModel>? get collections => _cached;
}
