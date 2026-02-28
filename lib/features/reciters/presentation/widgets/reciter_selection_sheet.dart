import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/reciter.dart';
import '../cubit/reciter_cubit.dart';
import '../cubit/reciter_state.dart';
import 'reciter_list_item.dart';

/// Bottom sheet for selecting a reciter from the Quran Reader audio card.
class ReciterSelectionSheet extends StatelessWidget {
  const ReciterSelectionSheet({
    super.key,
    required this.currentReciter,
    required this.isDark,
    required this.onReciterSelected,
  });

  final Reciter currentReciter;
  final bool isDark;
  final ValueChanged<Reciter> onReciterSelected;

  static Future<void> show(
    BuildContext context, {
    required Reciter currentReciter,
    required bool isDark,
    required ValueChanged<Reciter> onReciterSelected,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => ReciterSelectionSheet(
        currentReciter: currentReciter,
        isDark: isDark,
        onReciterSelected: onReciterSelected,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    final l10n = AppLocalizations.of(context);

    return BlocProvider(
      create: (_) => sl<ReciterCubit>(),
      child: DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.4,
        maxChildSize: 0.95,
        builder: (_, controller) => Container(
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkCard : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              _buildHandle(isDark),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.teal.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.record_voice_over_rounded,
                        color: AppColors.teal,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      l10n.translate('chooseReciter'),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: BlocConsumer<ReciterCubit, ReciterState>(
                  listenWhen: (a, b) =>
                      a.selectedReciter?.id != b.selectedReciter?.id,
                  listener: (context, state) {
                    if (state.selectedReciter != null) {
                      onReciterSelected(state.selectedReciter!);
                      Navigator.of(context).pop();
                    }
                  },
                  builder: (context, state) {
                    final popular =
                        state.reciters.where((r) => r.isPopular).toList();
                    final others =
                        state.reciters.where((r) => !r.isPopular).toList();

                    return ListView(
                      controller: controller,
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
                      children: [
                        if (popular.isNotEmpty) ...[
                          _SectionLabel(
                            l10n.translate('popularReciters'),
                            isDark: isDark,
                          ),
                          ...popular.map(
                            (r) => Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: ReciterListItem(
                                reciter: r,
                                isSelected:
                                    state.selectedReciter?.id == r.id,
                                isDark: isDark,
                                isRtl: isRtl,
                                onTap: () =>
                                    context.read<ReciterCubit>().selectReciter(r),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                        if (others.isNotEmpty) ...[
                          _SectionLabel(
                            l10n.translate('allReciters'),
                            isDark: isDark,
                          ),
                          ...others.map(
                            (r) => Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: ReciterListItem(
                                reciter: r,
                                isSelected:
                                    state.selectedReciter?.id == r.id,
                                isDark: isDark,
                                isRtl: isRtl,
                                onTap: () =>
                                    context.read<ReciterCubit>().selectReciter(r),
                              ),
                            ),
                          ),
                        ],
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHandle(bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 8),
      child: Container(
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: isDark ? Colors.white24 : Colors.black26,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.title, {required this.isDark});

  final String title;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: isDark ? Colors.white54 : Colors.black54,
        ),
      ),
    );
  }
}
