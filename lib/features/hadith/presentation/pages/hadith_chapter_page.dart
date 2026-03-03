import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/chapter_entity.dart';
import '../../domain/repositories/hadith_repository.dart';
import '../cubit/hadith_cubit.dart';
import '../cubit/hadith_state.dart';
import '../widgets/hadith_card.dart';

class HadithChapterPage extends StatelessWidget {
  const HadithChapterPage({
    super.key,
    required this.collectionId,
    required this.chapterId,
  });

  final String collectionId;
  final String chapterId;

  @override
  Widget build(BuildContext context) {
    final repo = sl<HadithRepository>();
    final chapters = repo.getChapters(collectionId);
    ChapterEntity? chapter;
    for (final ch in chapters) {
      if (ch.id == chapterId) {
        chapter = ch;
        break;
      }
    }
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final hadiths = chapter?.hadiths ?? [];

    return Scaffold(
      backgroundColor: AppColors.surface(context),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 20,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
          onPressed: () => context.pop(),
        ),
        title: Text(
          chapter?.titleAr ?? '',
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
        centerTitle: true,
      ),
      body: BlocProvider(
        create: (_) => sl<HadithCubit>()..load(),
        child: ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
          itemCount: hadiths.length,
          itemBuilder: (context, index) {
            final h = hadiths[index];
            return BlocBuilder<HadithCubit, HadithState>(
              buildWhen: (p, c) => p.favoriteIds != c.favoriteIds,
              builder: (context, state) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: HadithCard(
                    hadith: h,
                    isDark: isDark,
                    isFavorite: state.favoriteIds.contains(h.id),
                    onToggleFavorite: () {
                      context.read<HadithCubit>().toggleFavorite(h.id);
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
