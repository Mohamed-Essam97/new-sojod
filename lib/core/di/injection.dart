import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../core/services/prayer_service.dart';
import '../../features/prayer/presentation/cubit/prayer_cubit.dart';
import '../../features/quran/data/repositories/quran_repository_impl.dart';
import '../../features/quran/domain/repositories/quran_repository.dart';
import '../../features/quran/presentation/cubit/quran_cubit.dart';
import '../../features/settings/data/repositories/settings_repository_impl.dart';
import '../../features/settings/domain/repositories/settings_repository.dart';
import '../../features/settings/presentation/cubit/settings_cubit.dart';
import '../../features/home/presentation/cubit/home_cubit.dart';
import '../../features/adhkar/data/repositories/adhkar_repository_impl.dart';
import '../../features/adhkar/domain/repositories/adhkar_repository.dart';
import '../../features/adhkar/presentation/cubit/adhkar_cubit.dart';
import '../../features/hijri/data/repositories/hijri_repository_impl.dart';
import '../../features/hijri/domain/repositories/hijri_repository.dart';
import '../../features/hijri/presentation/cubit/hijri_cubit.dart';
import '../../features/tasbeeh/data/repositories/tasbeeh_repository_impl.dart';
import '../../features/tasbeeh/domain/repositories/tasbeeh_repository.dart';
import '../../features/tasbeeh/presentation/cubit/tasbeeh_cubit.dart';
import '../../features/notifications/data/repositories/notification_repository_impl.dart';
import '../../features/notifications/data/services/notification_service.dart';
import '../../features/notifications/domain/repositories/notification_repository.dart';
import '../../features/notifications/presentation/cubit/notification_cubit.dart';

final sl = GetIt.instance;

Future<void> initInjection() async {
  // External
  final prefs = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => prefs);

  await Hive.initFlutter();
  await Hive.openBox('adhkar_progress');
  await Hive.openBox('bookmarks');

  // Settings
  sl.registerLazySingleton<SettingsRepository>(
    () => SettingsRepositoryImpl(sharedPreferences: sl()),
  );
  sl.registerFactory<SettingsCubit>(() => SettingsCubit(sl()));

  // Prayer (uses adhan package directly)
  sl.registerLazySingleton<PrayerService>(() => PrayerService(sl<SharedPreferences>()));
  sl.registerFactory<PrayerCubit>(() => PrayerCubit(sl()));

  // Quran
  sl.registerLazySingleton<QuranRepository>(() => QuranRepositoryImpl(prefs: sl()));
  sl.registerFactory<QuranCubit>(() => QuranCubit(sl()));

  // Adhkar
  sl.registerLazySingleton<AdhkarRepository>(
    () => AdhkarRepositoryImpl(box: Hive.box('adhkar_progress')),
  );
  sl.registerFactory<AdhkarCubit>(() => AdhkarCubit(sl()));

  // Hijri
  sl.registerLazySingleton<HijriRepository>(
    () => HijriRepositoryImpl(sharedPreferences: sl()),
  );
  sl.registerFactory<HijriCubit>(() => HijriCubit(sl()));

  // Tasbeeh
  sl.registerLazySingleton<TasbeehRepository>(
    () => TasbeehRepositoryImpl(sharedPreferences: sl()),
  );
  sl.registerFactory<TasbeehCubit>(() => TasbeehCubit(sl()));

  // Notifications
  sl.registerLazySingleton<NotificationService>(
    () => NotificationService(),
  );
  sl.registerLazySingleton<NotificationRepository>(
    () => NotificationRepositoryImpl(
      prefs: sl(),
      service: sl<NotificationService>(),
    ),
  );
  sl.registerFactory<NotificationCubit>(
    () => NotificationCubit(sl(), sl<PrayerService>()),
  );

  // Home
  sl.registerFactory<HomeCubit>(() => HomeCubit(sl(), sl(), sl(), sl()));
}
