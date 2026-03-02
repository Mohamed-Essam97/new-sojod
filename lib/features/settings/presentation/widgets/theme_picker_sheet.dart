import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/app_restart.dart';
import '../../../../core/localization/app_localizations.dart';
import '../cubit/settings_cubit.dart';
import 'picker_option.dart';
import 'sheet_handle.dart';

class ThemePickerSheet extends StatelessWidget {
  final ThemeMode current;
  final bool isDark;

  const ThemePickerSheet({
    super.key,
    required this.current,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    final options = [
      (
        ThemeMode.system,
        Icons.brightness_auto_rounded,
        l10n.translate('systemDefault'),
        l10n.translate('followDeviceSetting'),
      ),
      (
        ThemeMode.light,
        Icons.wb_sunny_rounded,
        l10n.translate('light'),
        l10n.translate('alwaysLightTheme'),
      ),
      (
        ThemeMode.dark,
        Icons.nightlight_round,
        l10n.translate('dark'),
        l10n.translate('alwaysDarkTheme'),
      ),
    ];

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SheetHandle(isDark: isDark),
            const SizedBox(height: 16),
            Text(
              l10n.translate('chooseTheme'),
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            ...options.map((opt) {
              final isSelected = opt.$1 == current;
              return PickerOption(
                icon: opt.$2,
                title: opt.$3,
                subtitle: opt.$4,
                isSelected: isSelected,
                isDark: isDark,
                onTap: () async {
                  await context.read<SettingsCubit>().setThemeMode(opt.$1);
                  if (context.mounted) {
                    AppRestart.restart();
                    Navigator.pop(context);
                  }
                },
              );
            }),
          ],
        ),
      ),
    );
  }
}
