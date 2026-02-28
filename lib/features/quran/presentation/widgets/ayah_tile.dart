import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:quran_with_tafsir/quran_with_tafsir.dart';

import '../../../../core/theme/app_colors.dart';
import '../cubit/quran_cubit.dart';
import 'ayah_context_menu.dart';

class AyahTile extends StatelessWidget {
  const AyahTile({
    super.key,
    required this.ayah,
    required this.fontSize,
    required this.textColor,
    required this.audioPlayer,
    required this.cubit,
    required this.selectedAyahNotifier,
    required this.playingAyahNotifier,
  });

  final Ayah ayah;
  final double fontSize;
  final Color textColor;
  final AudioPlayer audioPlayer;
  final QuranCubit cubit;
  final ValueNotifier<int?> selectedAyahNotifier;
  final ValueNotifier<int?> playingAyahNotifier;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int?>(
      valueListenable: playingAyahNotifier,
      builder: (context, playingId, _) {
        return ValueListenableBuilder<int?>(
          valueListenable: selectedAyahNotifier,
          builder: (context, selectedId, _) {
            final isSelected = selectedId == ayah.id;
            final isPlaying = playingId == ayah.id;

            return GestureDetector(
              onLongPressStart: (details) {
                selectedAyahNotifier.value = ayah.id;
                AyahContextMenu.show(
                  context: context,
                  position: details.globalPosition,
                  ayah: ayah,
                  audioPlayer: audioPlayer,
                  cubit: cubit,
                ).then((_) {
                  if (selectedAyahNotifier.value == ayah.id) {
                    selectedAyahNotifier.value = null;
                  }
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                    horizontal: 3, vertical: 2),
                margin: const EdgeInsets.symmetric(horizontal: 1),
                decoration: BoxDecoration(
                  color: isPlaying
                      ? AppColors.teal.withValues(alpha: 0.22)
                      : isSelected
                          ? AppColors.teal.withValues(alpha: 0.12)
                          : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  border: isPlaying
                      ? Border.all(
                          color: AppColors.teal.withValues(alpha: 0.5),
                          width: 1,
                        )
                      : null,
                ),
                child: Text(
                  ayah.text,
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    fontFamily: 'QuranFont',
                    fontSize: fontSize,
                    height: 2.0,
                    color: isPlaying
                        ? AppColors.teal
                        : isSelected
                            ? AppColors.tealDark
                            : textColor,
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
