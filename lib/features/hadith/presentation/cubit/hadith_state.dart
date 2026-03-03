import '../../domain/entities/chapter_entity.dart';
import '../../domain/entities/collection_entity.dart';
import '../../domain/entities/hadith_entity.dart';

enum HadithScreen { collections, chapters, search }

class HadithState {
  const HadithState({
    this.collections = const [],
    this.selectedCollection,
    this.chapters = const [],
    this.searchQuery = '',
    this.searchResults = const [],
    this.favoriteIds = const {},
    this.isLoading = false,
    this.screen = HadithScreen.collections,
  });

  final List<CollectionEntity> collections;
  final CollectionEntity? selectedCollection;
  final List<ChapterEntity> chapters;
  final String searchQuery;
  final List<HadithEntity> searchResults;
  final Set<String> favoriteIds;
  final bool isLoading;
  final HadithScreen screen;

  HadithState copyWith({
    List<CollectionEntity>? collections,
    CollectionEntity? selectedCollection,
    List<ChapterEntity>? chapters,
    String? searchQuery,
    List<HadithEntity>? searchResults,
    Set<String>? favoriteIds,
    bool? isLoading,
    HadithScreen? screen,
  }) {
    return HadithState(
      collections: collections ?? this.collections,
      selectedCollection: selectedCollection ?? this.selectedCollection,
      chapters: chapters ?? this.chapters,
      searchQuery: searchQuery ?? this.searchQuery,
      searchResults: searchResults ?? this.searchResults,
      favoriteIds: favoriteIds ?? this.favoriteIds,
      isLoading: isLoading ?? this.isLoading,
      screen: screen ?? this.screen,
    );
  }

  List<HadithEntity> get favoriteHadiths => [];
}
