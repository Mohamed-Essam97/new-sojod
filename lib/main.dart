import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';

import 'core/app_restart.dart';
import 'core/di/injection.dart';
import 'core/localization/app_localizations.dart';
import 'core/routing/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/audio_player/domain/entities/playback_state.dart';
import 'features/audio_player/presentation/cubit/audio_player_cubit.dart';
import 'features/audio_player/presentation/widgets/persistent_audio_player.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';
import 'features/notifications/data/services/notification_service.dart';
import 'features/notifications/presentation/cubit/notification_cubit.dart';
import 'features/settings/presentation/cubit/settings_cubit.dart';
import 'features/settings/presentation/cubit/settings_state.dart';
import 'features/wird/presentation/cubit/wird_cubit.dart';
import 'firebase_options.dart';

late final GoRouter _appRouter;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: WidgetsBinding.instance);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await initInjection();
  await sl<NotificationService>().initialize();
  _appRouter = createAppRouter();
  runApp(
    ValueListenableBuilder<int>(
      valueListenable: appRestartKey,
      builder: (context, key, child) => WirdApp(key: ValueKey(key)),
    ),
  );
}

class WirdApp extends StatelessWidget {
  const WirdApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<SettingsCubit>()..loadSettings()),
        BlocProvider(create: (_) => sl<NotificationCubit>()..init()),
        BlocProvider(create: (_) => sl<AudioPlayerCubit>()),
        BlocProvider(create: (_) => sl<AuthCubit>()..checkAuthStatus()),
        BlocProvider.value(value: sl<WirdCubit>()),
      ],
      child: BlocBuilder<SettingsCubit, SettingsState>(
        buildWhen: (prev, curr) =>
            prev.locale != curr.locale || prev.themeMode != curr.themeMode,
        builder: (context, state) {
          final isRtl = state.locale.languageCode == 'ar';
          return MaterialApp.router(
            title: "Wird",
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: state.themeMode,
            locale: state.locale,
            routerConfig: _appRouter,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en'),
              Locale('ar'),
            ],
            builder: (context, child) => Directionality(
              textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
              child: Stack(
                children: [
                  child!,
                  BlocBuilder<AudioPlayerCubit, AudioPlaybackState>(
                    buildWhen: (prev, curr) =>
                        prev.isIdle != curr.isIdle ||
                        prev.isPlaying != curr.isPlaying,
                    builder: (context, state) {
                      if (state.isIdle || !state.isPlaying) {
                        return const SizedBox.shrink();
                      }
                      return RepaintBoundary(
                        child: const PersistentAudioPlayer(),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
