import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/collection_entity.dart';
import '../../domain/entities/hadith_entity.dart';
import '../../domain/repositories/hadith_repository.dart';
import 'hadith_state.dart';

class HadithCubit extends Cubit<HadithState> {
  HadithCubit(this._repository) : super(const HadithState());

  final HadithRepository _repository;

  Future<void> load() async {
    emit(state.copyWith(isLoading: true));
    await _repository.ensureLoaded();
    final collections = _repository.getCollections();
    final favoriteIds = await _repository.getFavoriteIds();
    emit(state.copyWith(
      collections: collections,
      favoriteIds: favoriteIds,
      isLoading: false,
      screen: HadithScreen.collections,
    ));
  }

  void selectCollection(CollectionEntity collection) {
    final chapters = _repository.getChapters(collection.id);
    emit(state.copyWith(
      selectedCollection: collection,
      chapters: chapters,
      screen: HadithScreen.chapters,
    ));
  }

  void backToCollections() {
    emit(state.copyWith(
      selectedCollection: null,
      chapters: [],
      screen: HadithScreen.collections,
    ));
  }

  void search(String query) {
    if (query.trim().isEmpty) {
      emit(state.copyWith(searchQuery: '', searchResults: [], screen: HadithScreen.collections));
      return;
    }
    final results = _repository.searchHadiths(query);
    emit(state.copyWith(
      searchQuery: query,
      searchResults: results,
      screen: HadithScreen.search,
    ));
  }

  void clearSearch() {
    emit(state.copyWith(searchQuery: '', searchResults: [], screen: HadithScreen.collections));
  }

  void showSearchScreen() {
    emit(state.copyWith(screen: HadithScreen.search, searchResults: []));
  }

  Future<void> toggleFavorite(String hadithId) async {
    final newSet = await _repository.toggleFavorite(hadithId);
    emit(state.copyWith(favoriteIds: newSet));
  }

  Future<void> refreshFavorites() async {
    final favoriteIds = await _repository.getFavoriteIds();
    emit(state.copyWith(favoriteIds: favoriteIds));
  }

  HadithEntity? getHadithById(String id) => _repository.getHadithById(id);

  /// Resolve favorite ids to entities for "Favorites" list.
  List<HadithEntity> getFavoriteHadiths() {
    final list = <HadithEntity>[];
    for (final id in state.favoriteIds) {
      final h = _repository.getHadithById(id);
      if (h != null) list.add(h);
    }
    return list;
  }
}
