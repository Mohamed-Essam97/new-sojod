import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/hadith_entity.dart';
import '../../domain/repositories/hadith_repository.dart';
import '../cubit/hadith_cubit.dart';
import '../cubit/hadith_state.dart';

class HadithDetailPage extends StatelessWidget {
  const HadithDetailPage({super.key, required this.hadithId});

  final String hadithId;

  @override
  Widget build(BuildContext context) {
    final repo = sl<HadithRepository>();
    final hadith = repo.getHadithById(hadithId);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);

    if (hadith == null) {
      return Scaffold(
        backgroundColor: AppColors.surface(context),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
            ),
            onPressed: () => context.pop(),
          ),
        ),
        body: Center(
          child: Text(
            l10n.translate('hadithNotFound'),
            style: TextStyle(
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
            ),
          ),
        ),
      );
    }

    return BlocProvider(
      create: (_) => sl<HadithCubit>()..load(),
      child: _HadithDetailView(hadith: hadith),
    );
  }
}

class _HadithDetailView extends StatelessWidget {
  const _HadithDetailView({required this.hadith});

  final HadithEntity hadith;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
          '${hadith.collectionNameAr ?? ''} · ${hadith.number}',
          textDirection: TextDirection.rtl,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        centerTitle: true,
        actions: [
          BlocBuilder<HadithCubit, HadithState>(
            buildWhen: (p, c) => p.favoriteIds != c.favoriteIds,
            builder: (context, state) {
              final isFav = state.favoriteIds.contains(hadith.id);
              return IconButton(
                icon: Icon(
                  isFav ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                  color: isFav ? AppColors.teal : (isDark ? AppColors.textSecondaryDark : AppColors.grey),
                ),
                onPressed: () => context.read<HadithCubit>().toggleFavorite(hadith.id),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.teal.withValues(alpha: isDark ? 0.2 : 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                hadith.referenceAr,
                textDirection: TextDirection.rtl,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.teal,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              hadith.arabic,
              textDirection: TextDirection.rtl,
              style: TextStyle(
                fontFamily: 'QuranFont',
                fontSize: 22,
                height: 1.8,
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              hadith.referenceEn,
              style: TextStyle(
                fontSize: 13,
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
