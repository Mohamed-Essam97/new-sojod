import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/adhkar/presentation/pages/adhkar_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/profile_page.dart';
import '../../features/hijri/presentation/pages/hijri_page.dart';
import '../../features/mosque/presentation/pages/mosque_page.dart';
import '../../features/permissions/presentation/pages/permissions_page.dart';
import '../../features/prayer/presentation/pages/prayer_7days_page.dart';
import '../../features/prayer/presentation/pages/prayer_page.dart';
import '../../features/qibla/presentation/pages/qibla_page.dart';
import '../../features/quran/presentation/pages/quran_page.dart';
import '../../features/quran/presentation/pages/quran_reader_page.dart';
import '../../features/reciters/presentation/pages/reciter_selection_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../features/shell/presentation/pages/home_shell_screen.dart';
import '../../features/splash/presentation/pages/splash_page.dart';
import '../../features/tasbeeh/presentation/pages/tasbeeh_page.dart';
import '../../features/wird/presentation/pages/wird_dashboard_page.dart';
import '../../features/groups/presentation/pages/groups_list_page.dart';
import '../../features/groups/presentation/pages/group_details_page.dart';
import '../../features/groups/presentation/pages/join_group_page.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

GoRouter createAppRouter() {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: '/permissions',
        builder: (context, state) => const PermissionsPage(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomeShellScreen(),
      ),
      GoRoute(
        path: '/prayer',
        builder: (context, state) => const PrayerPage(),
      ),
      GoRoute(
        path: '/prayer/7days',
        builder: (context, state) => const Prayer7DaysPage(),
      ),
      GoRoute(
        path: '/quran',
        builder: (context, state) => const QuranPage(),
      ),
      GoRoute(
        path: '/quran/reader',
        builder: (context, state) {
          final page = state.uri.queryParameters['page'];
          final surah = state.uri.queryParameters['surah'];
          return QuranReaderPage(
            initialPage: page != null ? (int.tryParse(page) ?? 1) : 1,
            initialSurah: surah != null ? int.tryParse(surah) : null,
          );
        },
      ),
      GoRoute(
        path: '/adhkar',
        builder: (context, state) => const AdhkarPage(),
      ),
      GoRoute(
        path: '/hijri',
        builder: (context, state) => const HijriPage(),
      ),
      GoRoute(
        path: '/qibla',
        builder: (context, state) => const QiblaPage(),
      ),
      GoRoute(
        path: '/mosque',
        builder: (context, state) => const MosquePage(),
      ),
      GoRoute(
        path: '/tasbeeh',
        builder: (context, state) => const TasbeehPage(),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsPage(),
      ),
      GoRoute(
        path: '/reciters',
        builder: (context, state) => const ReciterSelectionPage(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfilePage(),
      ),
      GoRoute(
        path: '/wird',
        builder: (context, state) => const WirdDashboardPage(),
      ),
      GoRoute(
        path: '/groups',
        builder: (context, state) => const GroupsListPage(),
      ),
      GoRoute(
        path: '/groups/join',
        builder: (context, state) => const JoinGroupPage(),
      ),
      GoRoute(
        path: '/groups/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return GroupDetailsPage(groupId: id);
        },
      ),
    ],
  );
}
