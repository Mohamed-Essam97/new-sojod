import 'package:flutter/material.dart';
import 'app_colors.dart';

enum QuranReadingThemeType {
  light,
  sepia,
  dark,
  green,
  blue,
  pink,
}

extension QuranReadingThemeTypeExt on QuranReadingThemeType {
  Color get background {
    switch (this) {
      case QuranReadingThemeType.light:
        return Colors.white;
      case QuranReadingThemeType.sepia:
        return AppColors.sepiaBackground;
      case QuranReadingThemeType.dark:
        return AppColors.darkBackground;
      case QuranReadingThemeType.green:
        return AppColors.greenBackground;
      case QuranReadingThemeType.blue:
        return AppColors.blueBackground;
      case QuranReadingThemeType.pink:
        return AppColors.pinkBackground;
    }
  }

  Color get textColor {
    switch (this) {
      case QuranReadingThemeType.light:
        return Colors.black87;
      case QuranReadingThemeType.sepia:
        return AppColors.sepiaText;
      case QuranReadingThemeType.dark:
        return Colors.white;
      case QuranReadingThemeType.green:
        return AppColors.greenText;
      case QuranReadingThemeType.blue:
        return AppColors.blueText;
      case QuranReadingThemeType.pink:
        return AppColors.pinkText;
    }
  }
}
