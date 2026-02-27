import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/adhkar_category_entity.dart';
import '../cubit/adhkar_cubit.dart';
import '../cubit/adhkar_state.dart';
import 'category_meta.dart';
import 'detail_app_bar.dart';
import 'dhikr_card.dart';

class AdhkarDetailPage extends StatefulWidget {
  const AdhkarDetailPage({
    super.key,
    required this.category,
  });

  final AdhkarCategoryEntity category;

  @override
  State<AdhkarDetailPage> createState() => _AdhkarDetailPageState();
}

class _AdhkarDetailPageState extends State<AdhkarDetailPage> {
  late final PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _next() {
    if (_currentIndex < widget.category.dhikrs.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final meta = getCategoryMeta(widget.category.id);
    final dhikrs = widget.category.dhikrs;

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.darkBackground : const Color(0xFFF7FAFA),
      body: Column(
        children: [
          DetailAppBar(
            category: widget.category,
            meta: meta,
            current: _currentIndex + 1,
            total: dhikrs.length,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Row(
              children: List.generate(dhikrs.length, (i) {
                final done = i < _currentIndex;
                final active = i == _currentIndex;
                return Expanded(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    height: 4,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: done || active
                          ? meta.color
                          : meta.color.withValues(alpha: 0.15),
                    ),
                  ),
                );
              }),
            ),
          ),
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: (i) => setState(() => _currentIndex = i),
              itemCount: dhikrs.length,
              itemBuilder: (ctx, i) {
                return BlocBuilder<AdhkarCubit, AdhkarState>(
                  builder: (context, state) {
                    final progress = state.progressMap[widget.category.id];
                    final dhikr = dhikrs[i];
                    final dhikrKey = '${i}_${dhikr.arabic.hashCode}';
                    final currentCount = progress?[dhikrKey] ?? 0;
                    return DhikrCard(
                      dhikr: dhikr,
                      index: i,
                      dhikrKey: dhikrKey,
                      categoryId: widget.category.id,
                      currentCount: currentCount,
                      meta: meta,
                      l10n: AppLocalizations.of(context),
                      onComplete: _next,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
