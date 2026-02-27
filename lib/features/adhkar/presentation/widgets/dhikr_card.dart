import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/adhkar_category_entity.dart';
import '../cubit/adhkar_cubit.dart';
import 'category_meta.dart';
import 'counter_widget.dart';

class DhikrCard extends StatelessWidget {
  const DhikrCard({
    super.key,
    required this.dhikr,
    required this.index,
    required this.dhikrKey,
    required this.categoryId,
    required this.currentCount,
    required this.meta,
    required this.l10n,
    required this.onComplete,
  });

  final DhikrEntity dhikr;
  final int index;
  final String dhikrKey;
  final String categoryId;
  final int currentCount;
  final CategoryMeta meta;
  final AppLocalizations l10n;
  final VoidCallback onComplete;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isComplete = currentCount >= dhikr.count;
    final progress = dhikr.count > 0
        ? (currentCount / dhikr.count).clamp(0.0, 1.0)
        : 0.0;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCard : Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: isComplete
                    ? meta.color.withValues(alpha: 0.4)
                    : (isDark
                        ? Colors.white.withValues(alpha: 0.06)
                        : Colors.grey.withValues(alpha: 0.1)),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: meta.color.withValues(alpha: isDark ? 0.08 : 0.06),
                  blurRadius: 20,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: meta.color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '× ${dhikr.count}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: meta.color,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  dhikr.arabic,
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontFamily: 'Amiri',
                    height: 2.0,
                    color: isDark ? Colors.white : const Color(0xFF1A1A2E),
                  ),
                ),
                if (dhikr.transliteration != null) ...[
                  const SizedBox(height: 16),
                  Divider(
                    color: isDark
                        ? Colors.white12
                        : Colors.grey.withValues(alpha: 0.15),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    dhikr.transliteration!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      fontStyle: FontStyle.italic,
                      color: isDark ? Colors.white54 : const Color(0xFF5A7A7A),
                      height: 1.6,
                    ),
                  ),
                ],
                if (dhikr.translation != null) ...[
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: meta.color.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      dhikr.translation!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12.5,
                        color: isDark
                            ? Colors.white60
                            : const Color(0xFF4A6060),
                        height: 1.6,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 24),
          CounterWidget(
            current: currentCount,
            target: dhikr.count,
            progress: progress,
            isComplete: isComplete,
            meta: meta,
            l10n: l10n,
            onTap: () {
              if (!isComplete) {
                HapticFeedback.lightImpact();
                context.read<AdhkarCubit>().incrementDhikr(
                      categoryId,
                      dhikrKey,
                      dhikr.count,
                    );
              } else {
                HapticFeedback.mediumImpact();
                onComplete();
              }
            },
            onReset: () {
              context.read<AdhkarCubit>().resetDhikr(categoryId, dhikrKey);
            },
          ),
          const SizedBox(height: 24),
          if (isComplete)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: meta.color,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                icon: const Icon(Icons.arrow_forward_rounded),
                label: Text(
                  l10n.translate('nextDhikr'),
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w600),
                ),
                onPressed: onComplete,
              ),
            ),
        ],
      ),
    );
  }
}
