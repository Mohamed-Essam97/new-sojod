import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../reciters/domain/repositories/reciter_repository.dart';
import '../../../reciters/presentation/widgets/reciter_selection_sheet.dart';
import '../../domain/entities/playback_state.dart';
import '../cubit/audio_player_cubit.dart';

class PersistentAudioPlayer extends StatelessWidget {
  const PersistentAudioPlayer({super.key});

  static const TextStyle _playerTitleStyle = TextStyle(
    color: Colors.white,
    fontFamily: 'QuranFont',
    fontSize: 15,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle _playerSubtitleStyle = TextStyle(
    color: Colors.white70,
    fontSize: 11,
  );

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AudioPlayerCubit, AudioPlaybackState>(
      buildWhen: (prev, curr) =>
          prev.isIdle != curr.isIdle ||
          prev.surahName != curr.surahName ||
          prev.currentIndex != curr.currentIndex ||
          prev.totalAyahs != curr.totalAyahs ||
          prev.isPlaying != curr.isPlaying ||
          prev.reciterName != curr.reciterName,
      builder: (context, state) {
        if (state.isIdle) return const SizedBox.shrink();

        final l10n = AppLocalizations.of(context);
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final reciter = sl<ReciterRepository>().getSelectedReciter();

        return Positioned(
          left: 16,
          right: 16,
          bottom: 80,
          child: Material(
            elevation: 12,
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.teal, AppColors.tealDark],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      // Reciter Avatar
                      ClipOval(
                        child: (reciter.imageUrl != null && reciter.imageUrl!.isNotEmpty)
                            ? Image.asset(
                                reciter.imageUrl!,
                                width: 40,
                                height: 40,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    _DefaultAvatar(),
                              )
                            : const _DefaultAvatar(),
                      ),
                      const SizedBox(width: 12),
                      // Surah & Ayah Info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              state.surahName ?? '',
                              style: _playerTitleStyle,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              '${l10n.translate('ayahOf', [
                                (state.currentIndex + 1).toString(),
                                state.totalAyahs.toString(),
                              ])} · ${state.reciterName ?? reciter.nameAr}',
                              style: _playerSubtitleStyle,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Change Reciter Button
                      GestureDetector(
                        onTap: () => _showReciterSelection(context, isDark),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.swap_horiz_rounded,
                                color: Colors.white,
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                l10n.translate('changeReciter'),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Playback Controls (follow app direction for RTL)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    textDirection: Directionality.of(context),
                    children: [
                      _PlayerButton(
                        icon: Icons.skip_previous_rounded,
                        onTap: () =>
                            context.read<AudioPlayerCubit>().skipPrevious(),
                      ),
                      _PlayerButton(
                        icon: state.isPlaying
                            ? Icons.pause_rounded
                            : Icons.play_arrow_rounded,
                        size: 32,
                        onTap: () =>
                            context.read<AudioPlayerCubit>().togglePlayPause(),
                      ),
                      _PlayerButton(
                        icon: Icons.skip_next_rounded,
                        onTap: () =>
                            context.read<AudioPlayerCubit>().skipNext(),
                      ),
                      _PlayerButton(
                        icon: Icons.close_rounded,
                        size: 20,
                        onTap: () => context.read<AudioPlayerCubit>().stop(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Progress Bar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(2),
                    child: LinearProgressIndicator(
                      value: state.totalAyahs > 0
                          ? (state.currentIndex + 1) / state.totalAyahs
                          : 0,
                      minHeight: 3,
                      backgroundColor: Colors.white.withValues(alpha: 0.3),
                      valueColor:
                          const AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _showReciterSelection(BuildContext context, bool isDark) async {
    final currentReciter = sl<ReciterRepository>().getSelectedReciter();
    await ReciterSelectionSheet.show(
      context,
      currentReciter: currentReciter,
      isDark: isDark,
      onReciterSelected: (newReciter) {
        context.read<AudioPlayerCubit>().changeReciter(newReciter);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                AppLocalizations.of(context).translate('reciterChangedSuccess'),
              ),
              behavior: SnackBarBehavior.floating,
              backgroundColor: AppColors.teal,
              duration: const Duration(seconds: 2),
            ),
          );
        }
      },
    );
  }
}

class _PlayerButton extends StatelessWidget {
  const _PlayerButton({
    required this.icon,
    required this.onTap,
    this.size = 24,
  });

  final IconData icon;
  final VoidCallback onTap;
  final double size;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.2),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: size),
      ),
    );
  }
}

class _DefaultAvatar extends StatelessWidget {
  const _DefaultAvatar();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: const BoxDecoration(
        color: AppColors.overlayLight,
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.person,
        color: Colors.white,
        size: 24,
      ),
    );
  }
}
