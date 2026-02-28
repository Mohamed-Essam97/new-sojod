import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/adhkar_category_entity.dart';
import '../cubit/adhkar_cubit.dart';
import '../cubit/adhkar_state.dart';
import '../widgets/adhkar_detail_page.dart';
import '../widgets/adhkar_header.dart';
import '../widgets/category_card.dart';

class AdhkarPage extends StatelessWidget {
  const AdhkarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AdhkarCubit>(),
      child: const _AdhkarView(),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Category listing view
// ─────────────────────────────────────────────────────────────────────────────

class _AdhkarView extends StatelessWidget {
  const _AdhkarView();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: BlocBuilder<AdhkarCubit, AdhkarState>(
        builder: (context, state) {
          return CustomScrollView(
            slivers: [
              AdhkarHeader(l10n: l10n),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
                sliver: SliverGrid(
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 14,
                    crossAxisSpacing: 14,
                    childAspectRatio: 1.05,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (ctx, i) {
                      final cat = state.categories[i];
                      final completed = state.getCompleted(cat.id);
                      final total = state.getTotal(cat.id);
                      return CategoryCard(
                        category: cat,
                        completed: completed,
                        total: total,
                        onTap: () => _openDetail(context, cat),
                      );
                    },
                    childCount: state.categories.length,
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          );
        },
      ),
    );
  }

  void _openDetail(
    BuildContext context,
    AdhkarCategoryEntity cat,
  ) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (ctx, anim, _) => BlocProvider.value(
          value: BlocProvider.of<AdhkarCubit>(context),
          child: AdhkarDetailPage(category: cat),
        ),
        transitionsBuilder: (ctx, anim, _, child) {
          return FadeTransition(
            opacity: anim,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.06, 0),
                end: Offset.zero,
              ).animate(CurvedAnimation(parent: anim, curve: Curves.easeOut)),
              child: child,
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 280),
      ),
    );
  }
}

