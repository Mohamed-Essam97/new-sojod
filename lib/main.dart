import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/di/injection.dart';
import 'core/theme/app_theme.dart';
import 'core/routing/app_router.dart';
import 'core/localization/app_localizations.dart';
import 'features/settings/presentation/cubit/settings_cubit.dart';
import 'features/settings/presentation/cubit/settings_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initInjection();
  runApp(const AlMuminApp());
}

class AlMuminApp extends StatelessWidget {
  const AlMuminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<SettingsCubit>()..loadSettings(),
      child: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) {
          final s = state as SettingsState?;
          if (s == null) return const SizedBox.shrink();
          final isRtl = s.locale.languageCode == 'ar';
          return MaterialApp.router(
            title: "Al-Mu'min",
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: s.themeMode,
            locale: s.locale,
            routerConfig: createAppRouter(),
            localizationsDelegates: const [AppLocalizations.delegate],
            supportedLocales: const [
              Locale('en'),
              Locale('ar'),
            ],
            builder: (context, child) => Directionality(
              textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
              child: child!,
            ),
          );
        },
      ),
    );
  }
}
