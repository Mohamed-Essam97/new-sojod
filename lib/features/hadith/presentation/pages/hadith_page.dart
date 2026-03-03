import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../cubit/hadith_cubit.dart';
import '../cubit/hadith_state.dart';
import '../widgets/hadith_card.dart';
import '../widgets/hadith_chapter_tile.dart';
import '../widgets/hadith_collection_card.dart';

class HadithPage extends StatefulWidget {
  const HadithPage({super.key});

  @override
  State<HadithPage> createState() => _HadithPageState();
}

class _HadithPageState extends State<HadithPage> {
  final _searchController = TextEditingController();
  final _searchFocus = FocusNode();

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isAr = l10n.locale.languageCode == 'ar';
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocProvider(
      create: (_) => sl<HadithCubit>()..load(),
      child: Scaffold(
        backgroundColor: AppColors.surface(context),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            l10n.translate('hadith'),
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 20,
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
            ),
          ),
          centerTitle: true,
        ),
        body: BlocConsumer<HadithCubit, HadithState>(
          listener: (context, state) {
            if (state.screen == HadithScreen.search && state.searchQuery.isNotEmpty) {
              _searchController.text = state.searchQuery;
            }
          },
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator(color: AppColors.teal));
            }

            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                    child: TextField(
                      controller: _searchController,
                      focusNode: _searchFocus,
                      textDirection: isAr ? TextDirection.rtl : TextDirection.ltr,
                      onChanged: (v) => context.read<HadithCubit>().search(v),
                      decoration: InputDecoration(
                        hintText: l10n.translate('searchHadith'),
                        hintStyle: TextStyle(
                          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                        ),
                        prefixIcon: Icon(
                          Icons.search_rounded,
                          color: isDark ? AppColors.textSecondaryDark : AppColors.grey,
                        ),
                        filled: true,
                        fillColor: isDark ? AppColors.darkCard : Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                    ),
                  ),
                ),
                if (state.screen == HadithScreen.collections) ...[
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                      child: Row(
                        children: [
                          Text(
                            l10n.translate('hadithCollections'),
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final c = state.collections[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: HadithCollectionCard(
                              collection: c,
                              isDark: isDark,
                              isAr: isAr,
                              onTap: () => context.read<HadithCubit>().selectCollection(c),
                            ),
                          );
                        },
                        childCount: state.collections.length,
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
                      child: Text(
                        l10n.translate('favorites'),
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                        ),
                      ),
                    ),
                  ),
                  if (state.favoriteIds.isEmpty)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        child: Text(
                          l10n.translate('noFavoritesYet'),
                          style: TextStyle(
                            fontSize: 14,
                            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                          ),
                        ),
                      ),
                    )
                  else
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final favHadiths = context.read<HadithCubit>().getFavoriteHadiths();
                            if (index >= favHadiths.length) return const SizedBox.shrink();
                            final h = favHadiths[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: HadithCard(
                                hadith: h,
                                isDark: isDark,
                                isFavorite: true,
                                onToggleFavorite: () => context.read<HadithCubit>().toggleFavorite(h.id),
                              ),
                            );
                          },
                          childCount: state.favoriteIds.length,
                        ),
                      ),
                    ),
                ],
                if (state.screen == HadithScreen.chapters && state.selectedCollection != null) ...[
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                      child: Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.arrow_back_ios_new_rounded,
                              size: 20,
                              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                            ),
                            onPressed: () => context.read<HadithCubit>().backToCollections(),
                          ),
                          Expanded(
                            child: Text(
                              state.selectedCollection!.nameAr,
                              textDirection: TextDirection.rtl,
                              style: TextStyle(
                                fontFamily: 'QuranFont',
                                fontWeight: FontWeight.w700,
                                fontSize: 18,
                                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final ch = state.chapters[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: HadithChapterTile(
                              chapter: ch,
                              isDark: isDark,
                              isAr: isAr,
                              onTap: () => context.push(
                                '/hadith/chapter?collectionId=${state.selectedCollection!.id}&chapterId=${ch.id}',
                              ),
                            ),
                          );
                        },
                        childCount: state.chapters.length,
                      ),
                    ),
                  ),
                ],
                if (state.screen == HadithScreen.search) ...[
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                      child: Text(
                        state.searchResults.isEmpty
                            ? l10n.translate('noHadithFound')
                            : '${state.searchResults.length} ${l10n.translate('hadithResults')}',
                        style: TextStyle(
                          fontSize: 14,
                          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                        ),
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final h = state.searchResults[index];
                          final isFav = state.favoriteIds.contains(h.id);
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: HadithCard(
                              hadith: h,
                              isDark: isDark,
                              isFavorite: isFav,
                              onToggleFavorite: () => context.read<HadithCubit>().toggleFavorite(h.id),
                            ),
                          );
                        },
                        childCount: state.searchResults.length,
                      ),
                    ),
                  ),
                ],
                const SliverToBoxAdapter(child: SizedBox(height: 100)),
              ],
            );
          },
        ),
      ),
    );
  }
}
