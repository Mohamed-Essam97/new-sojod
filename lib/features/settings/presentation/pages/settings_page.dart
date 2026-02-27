import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/localization/app_localizations.dart';
import '../cubit/settings_cubit.dart';
import '../cubit/settings_state.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<SettingsCubit>(),
      child: const _SettingsView(),
    );
  }
}

class _SettingsView extends StatelessWidget {
  const _SettingsView();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.translate('settings')),
      ),
      body: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) {
          final s = state as SettingsState? ?? const SettingsState(themeMode: ThemeMode.system, locale: Locale('en'), permissionsGranted: false);
          return ListView(
            children: [
              ListTile(
                title: Text(l10n.translate('appearance')),
                subtitle: Text(_themeModeLabel(s.themeMode, l10n)),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () => _showThemePicker(context, l10n),
              ),
              ListTile(
                title: Text(l10n.translate('language')),
                subtitle: Text(s.locale.languageCode == 'ar'
                    ? l10n.translate('arabic')
                    : l10n.translate('english')),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () => _showLanguagePicker(context, l10n),
              ),
              ListTile(
                title: Text(l10n.translate('permissions')),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () => context.go('/permissions'),
              ),
              const Divider(),
              ListTile(
                title: Text(l10n.translate('about')),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {},
              ),
            ],
          );
        },
      ),
    );
  }

  String _themeModeLabel(ThemeMode mode, AppLocalizations l10n) {
    switch (mode) {
      case ThemeMode.light:
        return l10n.translate('light');
      case ThemeMode.dark:
        return l10n.translate('dark');
      case ThemeMode.system:
        return l10n.translate('system');
    }
  }

  void _showThemePicker(BuildContext context, AppLocalizations l10n) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => BlocProvider.value(
        value: context.read<SettingsCubit>(),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: ThemeMode.values.map((mode) {
              return ListTile(
                title: Text(_themeModeLabel(mode, l10n)),
                onTap: () {
                  context.read<SettingsCubit>().setThemeMode(mode);
                  Navigator.pop(ctx);
                },
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  void _showLanguagePicker(BuildContext context, AppLocalizations l10n) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => BlocProvider.value(
        value: context.read<SettingsCubit>(),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text(l10n.translate('english')),
                onTap: () {
                  context.read<SettingsCubit>().setLocale(const Locale('en'));
                  Navigator.pop(ctx);
                },
              ),
              ListTile(
                title: Text(l10n.translate('arabic')),
                onTap: () {
                  context.read<SettingsCubit>().setLocale(const Locale('ar'));
                  Navigator.pop(ctx);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
