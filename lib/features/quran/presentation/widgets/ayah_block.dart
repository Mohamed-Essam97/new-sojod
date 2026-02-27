import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:quran_with_tafsir/quran_with_tafsir.dart';

import '../cubit/quran_cubit.dart';
import 'ayah_tile.dart';

class AyahBlock extends StatelessWidget {
  const AyahBlock({
    super.key,
    required this.ayahs,
    required this.fontSize,
    required this.textColor,
    required this.audioPlayer,
    required this.cubit,
    required this.selectedAyahNotifier,
    required this.playingAyahNotifier,
  });

  final List<Ayah> ayahs;
  final double fontSize;
  final Color textColor;
  final AudioPlayer audioPlayer;
  final QuranCubit cubit;
  final ValueNotifier<int?> selectedAyahNotifier;
  final ValueNotifier<int?> playingAyahNotifier;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Wrap(
        children: ayahs
            .map((ayah) => AyahTile(
                  ayah: ayah,
                  fontSize: fontSize,
                  textColor: textColor,
                  audioPlayer: audioPlayer,
                  cubit: cubit,
                  selectedAyahNotifier: selectedAyahNotifier,
                  playingAyahNotifier: playingAyahNotifier,
                ))
            .toList(),
      ),
    );
  }
}
