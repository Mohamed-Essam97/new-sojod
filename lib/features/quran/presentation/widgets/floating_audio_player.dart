import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../reciters/domain/entities/reciter.dart';
import 'wave_bars.dart';

class FloatingAudioPlayer extends StatelessWidget {
  const FloatingAudioPlayer({
    super.key,
    required this.isPlaying,
    required this.surahName,
    required this.totalAyahs,
    required this.playingIndexNotifier,
    required this.audioPlayer,
    required this.reciter,
    required this.l10n,
    required this.isRtl,
    required this.onPlay,
    required this.onStop,
    required this.onChangeReciter,
  });

  final bool isPlaying;
  final String surahName;
  final int totalAyahs;
  final ValueNotifier<int> playingIndexNotifier;
  final AudioPlayer audioPlayer;
  final Reciter reciter;
  final AppLocalizations l10n;
  final bool isRtl;
  final VoidCallback onPlay;
  final VoidCallback onStop;
  final VoidCallback onChangeReciter;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      switchInCurve: Curves.easeOutBack,
      switchOutCurve: Curves.easeIn,
      transitionBuilder: (child, animation) => SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.4),
          end: Offset.zero,
        ).animate(animation),
        child: FadeTransition(opacity: animation, child: child),
      ),
      child: isPlaying
          ? ReaderMiniPlayer(
              key: const ValueKey('playing'),
              surahName: surahName,
              totalAyahs: totalAyahs,
              playingIndexNotifier: playingIndexNotifier,
              audioPlayer: audioPlayer,
              reciter: reciter,
              l10n: l10n,
              isRtl: isRtl,
              onStop: onStop,
              onChangeReciter: onChangeReciter,
            )
          : ReaderPlayButton(
              key: const ValueKey('idle'),
              l10n: l10n,
              onPlay: onPlay,
            ),
    );
  }
}

class ReaderPlayButton extends StatelessWidget {
  const ReaderPlayButton({
    super.key,
    required this.l10n,
    required this.onPlay,
  });

  final AppLocalizations l10n;
  final VoidCallback onPlay;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: onPlay,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.teal, AppColors.tealDark],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(40),
            boxShadow: [
              BoxShadow(
                color: AppColors.teal.withValues(alpha: 0.4),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 26),
              const SizedBox(width: 8),
              Text(
                l10n.translate('playSurah'),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ReaderMiniPlayer extends StatelessWidget {
  const ReaderMiniPlayer({
    super.key,
    required this.surahName,
    required this.totalAyahs,
    required this.playingIndexNotifier,
    required this.audioPlayer,
    required this.reciter,
    required this.l10n,
    required this.isRtl,
    required this.onStop,
    required this.onChangeReciter,
  });

  final String surahName;
  final int totalAyahs;
  final ValueNotifier<int> playingIndexNotifier;
  final AudioPlayer audioPlayer;
  final Reciter reciter;
  final AppLocalizations l10n;
  final bool isRtl;
  final VoidCallback onStop;
  final VoidCallback onChangeReciter;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.teal, AppColors.tealDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.teal.withValues(alpha: 0.45),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ValueListenableBuilder<int>(
            valueListenable: playingIndexNotifier,
            builder: (context, index, _) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const WaveBars(),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          surahName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontFamily: 'QuranFont',
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          l10n.translate('ayahOf', [
                            (index + 1).toString(),
                            totalAyahs.toString(),
                          ]),
                          style: const TextStyle(
                            color: AppColors.onSurfaceMuted,
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '${((index + 1) / totalAyahs * 100).toInt()}%',
                    style: const TextStyle(
                      color: AppColors.onSurfaceMuted,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: onChangeReciter,
            child: Row(
              children: [
                SizedBox(
                  width: 32,
                  height: 32,
                  child: ClipOval(
                    child: reciter.imageUrl != null
                        ? Image.asset(
                            reciter.imageUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                _placeholderAvatar(),
                          )
                        : _placeholderAvatar(),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    isRtl ? reciter.nameAr : reciter.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: AppColors.onSurfaceMuted,
                  size: 18,
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          ValueListenableBuilder<int>(
            valueListenable: playingIndexNotifier,
            builder: (context, index, _) => ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: totalAyahs > 0 ? (index + 1) / totalAyahs : 0,
                minHeight: 3,
                backgroundColor: AppColors.overlayLight,
                valueColor:
                    const AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _PlayerIconBtn(
                icon: Icons.skip_previous_rounded,
                size: 26,
                onTap: () {
                  if (audioPlayer.hasPrevious) {
                    audioPlayer.seekToPrevious();
                  }
                },
              ),
              StreamBuilder<PlayerState>(
                stream: audioPlayer.playerStateStream,
                builder: (context, snapshot) {
                  final playing = snapshot.data?.playing ?? false;
                  return GestureDetector(
                    onTap: () => playing
                        ? audioPlayer.pause()
                        : audioPlayer.play(),
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: const BoxDecoration(
                        color: AppColors.overlayLight,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        playing
                            ? Icons.pause_rounded
                            : Icons.play_arrow_rounded,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                  );
                },
              ),
              _PlayerIconBtn(
                icon: Icons.skip_next_rounded,
                size: 26,
                onTap: () {
                  if (audioPlayer.hasNext) {
                    audioPlayer.seekToNext();
                  }
                },
              ),
              _PlayerIconBtn(
                icon: Icons.stop_rounded,
                size: 22,
                onTap: onStop,
                outlined: true,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _placeholderAvatar() {
    return Container(
      color: AppColors.overlayLight,
      child: Icon(
        Icons.person_rounded,
        color: AppColors.onSurfaceMuted,
        size: 18,
      ),
    );
  }
}

class _PlayerIconBtn extends StatelessWidget {
  const _PlayerIconBtn({
    required this.icon,
    required this.size,
    required this.onTap,
    this.outlined = false,
  });

  final IconData icon;
  final double size;
  final VoidCallback onTap;
  final bool outlined;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: outlined ? Colors.transparent : AppColors.overlayLight,
          shape: BoxShape.circle,
          border: outlined
              ? Border.all(
                  color: AppColors.onSurfaceMuted, width: 1.5)
              : null,
        ),
        child: Icon(icon, color: Colors.white, size: size),
      ),
    );
  }
}
