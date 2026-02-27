import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/localization/app_localizations.dart';
import '../cubit/settings_cubit.dart';
import 'picker_option.dart';
import 'sheet_handle.dart';

class LanguagePickerSheet extends StatelessWidget {
  final Locale current;
  final bool isDark;

  const LanguagePickerSheet({
    super.key,
    required this.current,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    final options = [
      (
        const Locale('en'),
        Icons.language_rounded,
        l10n.translate('english'),
        'English',
      ),
      (
        const Locale('ar'),
        Icons.translate_rounded,
        l10n.translate('arabic'),
        'العربية',
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
              l10n.translate('chooseLanguage'),
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            ...options.map((opt) {
              final isSelected = opt.$1.languageCode == current.languageCode;
              return PickerOption(
                icon: opt.$2,
                title: opt.$3,
                subtitle: opt.$4,
                isSelected: isSelected,
                isDark: isDark,
                onTap: () {
                  context.read<SettingsCubit>().setLocale(opt.$1);
                  Navigator.pop(context);
                },
              );
            }),
          ],
        ),
      ),
    );
  }
}
