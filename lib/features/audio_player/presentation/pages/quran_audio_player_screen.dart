import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../quran/domain/repositories/quran_repository.dart';
import '../../../reciters/domain/entities/reciter.dart';
import '../../../reciters/domain/repositories/reciter_repository.dart';
import '../../../reciters/presentation/widgets/reciter_selection_sheet.dart';
import '../cubit/audio_player_cubit.dart';
import '../widgets/persistent_audio_player.dart';

class QuranAudioPlayerScreen extends StatelessWidget {
  const QuranAudioPlayerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);
    final isAr = l10n.locale.languageCode == 'ar';
    final quranRepo = sl<QuranRepository>();
    final reciterRepo = sl<ReciterRepository>();
    final surahs = quranRepo.getAllSurahs();

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: AppBar(
        title: Text(isAr ? 'استماع إلى القرآن' : 'Quran Audio Player'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _ReciterCard(
                reciter: reciterRepo.getSelectedReciter(),
                isDark: isDark,
                isAr: isAr,
                onTap: () => _showReciterSheet(context, isDark),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                child: Text(
                  isAr ? 'اختر سورة' : 'Select Surah',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 120),
                  itemCount: surahs.length,
                  itemBuilder: (context, i) {
                    final s = surahs[i];
                    return Padding(
                      key: ValueKey<int>(s.number),
                      padding: const EdgeInsets.only(bottom: 8),
                      child: _SurahRow(
                        number: s.number,
                        nameAr: s.nameAr,
                        nameEn: s.nameEn,
                        ayahCount: s.ayahCount,
                        isDark: isDark,
                        isAr: isAr,
                        onTap: () => context.read<AudioPlayerCubit>().playSurah(s.number),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          const Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: PersistentAudioPlayer(),
          ),
        ],
      ),
    );
  }

  Future<void> _showReciterSheet(BuildContext context, bool isDark) async {
    final reciterRepo = sl<ReciterRepository>();
    final currentReciter = reciterRepo.getSelectedReciter();
    await ReciterSelectionSheet.show(
      context,
      currentReciter: currentReciter,
      isDark: isDark,
      onReciterSelected: (newReciter) {
        context.read<AudioPlayerCubit>().changeReciter(newReciter);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context).translate('reciterChangedSuccess')),
              behavior: SnackBarBehavior.floating,
              backgroundColor: AppColors.teal,
            ),
          );
        }
      },
    );
  }
}

class _ReciterCard extends StatelessWidget {
  const _ReciterCard({
    required this.reciter,
    required this.isDark,
    required this.isAr,
    required this.onTap,
  });

  final Reciter reciter;
  final bool isDark;
  final bool isAr;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Material(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                ClipOval(
                  child: (reciter.imageUrl != null && reciter.imageUrl!.isNotEmpty)
                      ? Image.asset(
                          reciter.imageUrl!,
                          width: 48,
                          height: 48,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => _avatarPlaceholder(),
                        )
                      : _avatarPlaceholder(),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isAr ? 'القارئ' : 'Reciter',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        isAr ? (reciter.nameAr) : (reciter.name),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: isDark ? AppColors.textSecondaryDark : AppColors.grey,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _avatarPlaceholder() {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: AppColors.teal.withValues(alpha: 0.2),
        shape: BoxShape.circle,
      ),
      child: const Icon(Icons.person_rounded, color: AppColors.teal, size: 28),
    );
  }
}

class _SurahRow extends StatelessWidget {
  const _SurahRow({
    required this.number,
    required this.nameAr,
    required this.nameEn,
    required this.ayahCount,
    required this.isDark,
    required this.isAr,
    required this.onTap,
  });

  final int number;
  final String nameAr;
  final String nameEn;
  final int ayahCount;
  final bool isDark;
  final bool isAr;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AudioPlayerCubit>().state;
    final isCurrent = state.currentSurah == number;

    return Material(
      color: isDark ? AppColors.darkCard : Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          margin: const EdgeInsets.only(bottom: 8,top: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: isCurrent
                ? Border.all(color: AppColors.teal, width: 1.5)
                : null,
          ),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: isCurrent
                      ? AppColors.teal
                      : (isDark ? AppColors.teal.withValues(alpha: 0.2) : AppColors.teal.withValues(alpha: 0.12)),
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: Text(
                  '$number',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: isCurrent ? Colors.white : AppColors.teal,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      nameAr,
                      style: TextStyle(
                        fontFamily: 'QuranFont',
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                      ),
                    ),
                    Text(
                      '$nameEn · $ayahCount ${isAr ? "آية" : "verses"}',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.play_circle_filled_rounded,
                color: isCurrent ? AppColors.teal : (isDark ? AppColors.textSecondaryDark : AppColors.grey),
                size: 32,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
