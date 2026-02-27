import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:quran_with_tafsir/quran_with_tafsir.dart';

import '../../../../core/theme/app_colors.dart';
import '../cubit/quran_cubit.dart';

class AyahSheet extends StatelessWidget {
  const AyahSheet({
    super.key,
    required this.ayah,
    required this.tafsir,
    required this.audioPlayer,
    required this.cubit,
  });

  final Ayah ayah;
  final String? tafsir;
  final AudioPlayer audioPlayer;
  final QuranCubit cubit;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final sheetBg = isDark ? AppColors.darkCard : Colors.white;
    final textPrimary = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;

    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.35,
      maxChildSize: 0.92,
      expand: false,
      builder: (_, controller) => Container(
        decoration: BoxDecoration(
          color: sheetBg,
          borderRadius:
              const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.greyLight,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _SheetAction(
                    icon: Icons.bookmark_add_outlined,
                    label: 'Bookmark',
                    onTap: () =>
                        cubit.toggleBookmark(ayah.surahNumber, ayah.id),
                  ),
                  const SizedBox(width: 8),
                  _SheetAction(
                    icon: Icons.volume_up_outlined,
                    label: 'Play',
                    onTap: () async {
                      final url =
                          cubit.getAudioUrl(ayah.surahNumber, ayah.id);
                      await audioPlayer.setUrl(url);
                      audioPlayer.play();
                    },
                  ),
                  const SizedBox(width: 8),
                  _SheetAction(
                    icon: Icons.share_outlined,
                    label: 'Share',
                    onTap: () {},
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: SingleChildScrollView(
                controller: controller,
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.teal.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '${ayah.surahNumber}:${ayah.id}',
                            style: const TextStyle(
                              color: AppColors.teal,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      ayah.text,
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontFamily: 'QuranFont',
                        fontSize: 24,
                        height: 2.0,
                        color: textPrimary,
                      ),
                    ),
                    if (tafsir != null) ...[
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Container(
                            width: 3,
                            height: 18,
                            decoration: BoxDecoration(
                              color: AppColors.teal,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Tafsir',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: textPrimary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        tafsir!,
                        textDirection: TextDirection.rtl,
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontFamily: 'TafsirFont',
                          fontSize: 15,
                          height: 1.9,
                          color: textPrimary.withValues(alpha: 0.85),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SheetAction extends StatelessWidget {
  const _SheetAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.teal.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: AppColors.teal),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                color: AppColors.teal,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
