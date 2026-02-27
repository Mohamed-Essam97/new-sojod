import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/quran_reading_theme.dart';
import '../cubit/quran_cubit.dart';
import '../cubit/quran_state.dart';

class ReaderSettingsSheet extends StatelessWidget {
  const ReaderSettingsSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QuranCubit, QuranState>(
      builder: (context, state) {
        final theme = Theme.of(context);
        final isDark = theme.brightness == Brightness.dark;
        final textPrimary = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
        final textSecondary = isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;
        final sheetBg = isDark ? AppColors.darkCard : Colors.white;

        return Container(
          decoration: BoxDecoration(
            color: sheetBg,
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 32,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.greyLight,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Reading Settings',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: textPrimary,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Font Size',
                      style: TextStyle(
                          color: textPrimary,
                          fontWeight: FontWeight.w500)),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.teal.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      state.fontSize.toInt().toString(),
                      style: const TextStyle(
                        color: AppColors.teal,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: AppColors.teal,
                  thumbColor: AppColors.teal,
                  inactiveTrackColor:
                      AppColors.teal.withValues(alpha: 0.2),
                  overlayColor: AppColors.teal.withValues(alpha: 0.1),
                ),
                child: Slider(
                  value: state.fontSize,
                  min: 16,
                  max: 36,
                  divisions: 10,
                  onChanged: (v) =>
                      context.read<QuranCubit>().setFontSize(v),
                ),
              ),
              const SizedBox(height: 16),
              Text('Theme',
                  style: TextStyle(
                      color: textPrimary,
                      fontWeight: FontWeight.w500)),
              const SizedBox(height: 12),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: QuranReadingThemeType.values.map((t) {
                  final selected = state.readingTheme == t.name;
                  return GestureDetector(
                    onTap: () =>
                        context.read<QuranCubit>().setReadingTheme(t.name),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: selected
                            ? AppColors.teal
                            : t.background.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: selected
                              ? AppColors.teal
                              : AppColors.greyLight,
                          width: 1.5,
                        ),
                      ),
                      child: Text(
                        t.name[0].toUpperCase() + t.name.substring(1),
                        style: TextStyle(
                          color:
                              selected ? Colors.white : textSecondary,
                          fontWeight: selected
                              ? FontWeight.w600
                              : FontWeight.w400,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        );
      },
    );
  }
}
