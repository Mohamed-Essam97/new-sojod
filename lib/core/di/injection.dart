import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/services/prayer_service.dart';
import '../../features/adhkar/data/repositories/adhkar_repository_impl.dart';
import '../../features/adhkar/domain/repositories/adhkar_repository.dart';
import '../../features/adhkar/presentation/cubit/adhkar_cubit.dart';
import '../../features/audio_player/presentation/cubit/audio_player_cubit.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/get_current_user.dart';
import '../../features/auth/domain/usecases/sign_in_with_facebook.dart';
import '../../features/auth/domain/usecases/sign_in_with_google.dart';
import '../../features/auth/domain/usecases/sign_out.dart';
import '../../features/auth/domain/usecases/update_profile.dart';
import '../../features/auth/domain/usecases/upload_profile_image.dart';
import '../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../features/hijri/data/repositories/hijri_repository_impl.dart';
import '../../features/hijri/domain/repositories/hijri_repository.dart';
import '../../features/hijri/presentation/cubit/hijri_cubit.dart';
import '../../features/home/presentation/cubit/home_cubit.dart';
import '../../features/notifications/data/repositories/notification_repository_impl.dart';
import '../../features/notifications/data/services/notification_service.dart';
import '../../features/notifications/domain/repositories/notification_repository.dart';
import '../../features/notifications/presentation/cubit/notification_cubit.dart';
import '../../features/prayer/presentation/cubit/prayer_cubit.dart';
import '../../features/quran/data/repositories/quran_repository_impl.dart';
import '../../features/quran/domain/repositories/quran_repository.dart';
import '../../features/quran/presentation/cubit/quran_cubit.dart';
import '../../features/reciters/data/repositories/reciter_repository_impl.dart';
import '../../features/reciters/domain/repositories/reciter_repository.dart';
import '../../features/reciters/domain/usecases/get_all_reciters.dart';
import '../../features/reciters/domain/usecases/get_selected_reciter.dart';
import '../../features/reciters/domain/usecases/set_selected_reciter.dart';
import '../../features/reciters/presentation/cubit/reciter_cubit.dart';
import '../../features/settings/data/repositories/settings_repository_impl.dart';
import '../../features/settings/domain/repositories/settings_repository.dart';
import '../../features/settings/presentation/cubit/settings_cubit.dart';
import '../../features/tasbeeh/data/repositories/tasbeeh_repository_impl.dart';
import '../../features/tasbeeh/domain/repositories/tasbeeh_repository.dart';
import '../../features/tasbeeh/presentation/cubit/tasbeeh_cubit.dart';
import '../../features/wird/data/repositories/wird_repository_impl.dart';
import '../../features/wird/domain/repositories/wird_repository.dart';
import '../../features/wird/domain/usecases/get_today_wird.dart';
import '../../features/wird/domain/usecases/save_wird.dart';
import '../../features/wird/domain/usecases/update_wird_progress.dart';
import '../../features/wird/domain/usecases/watch_today_wird.dart';
import '../../features/wird/presentation/cubit/wird_cubit.dart';
import '../../features/groups/data/repositories/group_repository_impl.dart';
import '../../features/groups/domain/repositories/group_repository.dart';
import '../../features/groups/domain/usecases/create_group.dart';
import '../../features/groups/domain/usecases/create_invite.dart';
import '../../features/groups/domain/usecases/get_group_members.dart';
import '../../features/groups/domain/usecases/get_user_groups.dart';
import '../../features/groups/domain/usecases/join_group.dart';
import '../../features/groups/presentation/cubit/group_cubit.dart';

final sl = GetIt.instance;

Future<void> initInjection() async {
  // External
  final prefs = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => prefs);

  await Hive.initFlutter();
  await Hive.openBox('adhkar_progress');
  await Hive.openBox('bookmarks');

  // Firebase
  sl.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  sl.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);
  sl.registerLazySingleton<GoogleSignIn>(
    () => GoogleSignIn(
      serverClientId:
          '405620285471-j6b6ar3747v01uopsf2hlsd4a6195i1i.apps.googleusercontent.com',
    ),
  );
  sl.registerLazySingleton<FacebookAuth>(() => FacebookAuth.instance);

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

  // Reciters
  sl.registerLazySingleton<ReciterRepository>(
    () => ReciterRepositoryImpl(prefs: sl()),
  );
  sl.registerLazySingleton<GetAllReciters>(
    () => GetAllReciters(sl()),
  );
  sl.registerLazySingleton<GetSelectedReciter>(
    () => GetSelectedReciter(sl()),
  );
  sl.registerLazySingleton<SetSelectedReciter>(
    () => SetSelectedReciter(sl()),
  );
  sl.registerFactory<ReciterCubit>(
    () => ReciterCubit(sl(), sl(), sl()),
  );

  // Audio Player (Global Singleton)
  sl.registerLazySingleton<AudioPlayerCubit>(
    () => AudioPlayerCubit(sl<QuranRepository>(), sl<ReciterRepository>()),
  );

  // Auth
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      firebaseAuth: sl(),
      firestore: sl(),
      googleSignIn: sl(),
      facebookAuth: sl(),
    ),
  );
  sl.registerLazySingleton<SignInWithGoogle>(() => SignInWithGoogle(sl()));
  sl.registerLazySingleton<SignInWithFacebook>(() => SignInWithFacebook(sl()));
  sl.registerLazySingleton<SignOut>(() => SignOut(sl()));
  sl.registerLazySingleton<GetCurrentUser>(() => GetCurrentUser(sl()));
  sl.registerLazySingleton<UpdateProfile>(() => UpdateProfile(sl()));
  sl.registerLazySingleton<UploadProfileImage>(() => UploadProfileImage(sl()));
  sl.registerLazySingleton<AuthCubit>(
    () => AuthCubit(
      signInWithGoogle: sl(),
      signInWithFacebook: sl(),
      signOut: sl(),
      getCurrentUser: sl(),
      updateProfile: sl(),
      uploadProfileImage: sl(),
      authRepository: sl(),
    ),
  );

  // Wird
  sl.registerLazySingleton<WirdRepository>(
    () => WirdRepositoryImpl(firestore: sl()),
  );
  sl.registerLazySingleton<GetTodayWird>(() => GetTodayWird(sl()));
  sl.registerLazySingleton<SaveWird>(() => SaveWird(sl()));
  sl.registerLazySingleton<UpdateWirdProgress>(() => UpdateWirdProgress(sl()));
  sl.registerLazySingleton<WatchTodayWird>(() => WatchTodayWird(sl()));
  sl.registerLazySingleton<WirdCubit>(
    () => WirdCubit(
      getTodayWird: sl(),
      saveWird: sl(),
      updateWirdProgress: sl(),
      watchTodayWird: sl(),
    ),
  );

  // Groups
  sl.registerLazySingleton<GroupRepository>(
    () => GroupRepositoryImpl(firestore: sl()),
  );
  sl.registerLazySingleton<CreateGroup>(() => CreateGroup(sl()));
  sl.registerLazySingleton<GetUserGroups>(() => GetUserGroups(sl()));
  sl.registerLazySingleton<CreateInvite>(() => CreateInvite(sl()));
  sl.registerLazySingleton<JoinGroup>(() => JoinGroup(sl()));
  sl.registerLazySingleton<GetGroupMembers>(() => GetGroupMembers(sl()));
  sl.registerFactory<GroupCubit>(
    () => GroupCubit(
      createGroup: sl(),
      getUserGroups: sl(),
      createInvite: sl(),
      joinGroup: sl(),
      getGroupMembers: sl(),
      groupRepository: sl(),
    ),
  );
}
