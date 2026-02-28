import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:quran_with_tafsir/quran_with_tafsir.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../cubit/quran_cubit.dart';

class AyahContextMenu {
  static Future<void> show({
    required BuildContext context,
    required Offset position,
    required Ayah ayah,
    required AudioPlayer audioPlayer,
    required QuranCubit cubit,
  }) async {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final screenSize = MediaQuery.of(context).size;
    final menuWidth = 200.0;
    final menuHeight = 280.0;

    double left = position.dx;
    double top = position.dy;

    if (left + menuWidth > screenSize.width) {
      left = screenSize.width - menuWidth - 16;
    }
    if (top + menuHeight > screenSize.height) {
      top = screenSize.height - menuHeight - 16;
    }

    await showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(left, top, left + menuWidth, top),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: isDark ? AppColors.darkCard : Colors.white,
      elevation: 8,
      items: [
        _buildMenuItem(
          value: 'play',
          icon: Icons.play_circle_outline_rounded,
          label: l10n.translate('playAyah'),
          isDark: isDark,
        ),
        _buildMenuItem(
          value: 'tafsir',
          icon: Icons.menu_book_rounded,
          label: l10n.translate('viewTafsir'),
          isDark: isDark,
        ),
        _buildMenuItem(
          value: 'translate',
          icon: Icons.translate_rounded,
          label: l10n.translate('translate'),
          isDark: isDark,
        ),
        _buildMenuItem(
          value: 'bookmark',
          icon: Icons.bookmark_add_outlined,
          label: l10n.translate('bookmark'),
          isDark: isDark,
        ),
        _buildMenuItem(
          value: 'share',
          icon: Icons.share_outlined,
          label: l10n.translate('share'),
          isDark: isDark,
        ),
      ],
    ).then((value) async {
      if (value == null || !context.mounted) return;

      switch (value) {
        case 'play':
          try {
            final url = cubit.getAudioUrl(ayah.surahNumber, ayah.id);
            await audioPlayer.setUrl(url);
            await audioPlayer.play();
          } catch (_) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(l10n.translate('audioPlayError')),
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: AppColors.red,
                ),
              );
            }
          }
          break;

        case 'tafsir':
          final tafsir = cubit.getTafsir(ayah.surahNumber)[ayah.id];
          if (context.mounted) {
            _showTafsirDialog(context, ayah, tafsir);
          }
          break;

        case 'translate':
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(l10n.translate('comingSoon')),
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
          break;

        case 'bookmark':
          cubit.toggleBookmark(ayah.surahNumber, ayah.id);
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(l10n.translate('bookmarkAdded')),
                behavior: SnackBarBehavior.floating,
                backgroundColor: AppColors.teal,
                duration: const Duration(seconds: 1),
              ),
            );
          }
          break;

        case 'share':
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(l10n.translate('comingSoon')),
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
          break;
      }
    });
  }

  static PopupMenuItem<String> _buildMenuItem({
    required String value,
    required IconData icon,
    required String label,
    required bool isDark,
  }) {
    final textColor = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;

    return PopupMenuItem<String>(
      value: value,
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.teal),
          const SizedBox(width: 12),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  static void _showTafsirDialog(BuildContext context, Ayah ayah, String? tafsir) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textPrimary = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final l10n = AppLocalizations.of(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? AppColors.darkCard : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        contentPadding: const EdgeInsets.all(24),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
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
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, size: 20),
                    onPressed: () => Navigator.of(context).pop(),
                    color: textPrimary,
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
                  fontSize: 22,
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
                      l10n.translate('tafsir'),
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: textPrimary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  tafsir,
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontFamily: 'TafsirFont',
                    fontSize: 15,
                    height: 1.9,
                    color: textPrimary.withValues(alpha: 0.85),
                  ),
                ),
              ] else ...[
                const SizedBox(height: 16),
                Text(
                  l10n.translate('noTafsirAvailable'),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: textPrimary.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
