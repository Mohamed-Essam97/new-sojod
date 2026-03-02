import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:quran_with_tafsir/quran_with_tafsir.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../auth/presentation/cubit/auth_state.dart';
import '../../../notifications/presentation/cubit/notification_cubit.dart';
import '../../../notifications/presentation/cubit/notification_state.dart';
import '../cubit/settings_cubit.dart';
import '../cubit/settings_state.dart';
import '../widgets/adhkar_notification_tile.dart';
import '../widgets/language_picker_sheet.dart';
import '../widgets/prayer_notification_sheet.dart';
import '../widgets/section_label.dart';
import '../widgets/settings_card.dart';
import '../widgets/settings_header.dart';
import '../widgets/settings_tile.dart';
import '../widgets/sleep_time_tile.dart';
import '../widgets/theme_picker_sheet.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<SettingsCubit>()),
      ],
      child: const _SettingsView(),
    );
  }
}

class _SettingsView extends StatelessWidget {
  const _SettingsView();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) {
          final isAr = state.locale.languageCode == 'ar';
          final reciterName = _reciterDisplayName(state.selectedReciter, isAr);

          return CustomScrollView(
            slivers: [
              const SettingsHeader(),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 40),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    SectionLabel(l10n.translate('appearance')),
                    SettingsCard(isDark: isDark, children: [
                      SettingsTile(
                        icon: Icons.brightness_6_rounded,
                        iconColor: AppColors.violet,
                        title: l10n.translate('theme'),
                        subtitle: _themeModeLabel(context, state.themeMode),
                        isDark: isDark,
                        onTap: () =>
                            _showThemePicker(context, state.themeMode),
                      ),
                    ]),
                    const SizedBox(height: 20),

                    SectionLabel(l10n.translate('quranReader')),
                    SettingsCard(isDark: isDark, children: [
                      SettingsTile(
                        icon: Icons.record_voice_over_rounded,
                        iconColor: AppColors.teal,
                        title: l10n.translate('reciter'),
                        subtitle: reciterName,
                        isDark: isDark,
                        onTap: () async {
                          await context.push('/reciters');
                          if (context.mounted) {
                            context.read<SettingsCubit>().loadSettings();
                          }
                        },
                      ),
                    ]),
                    const SizedBox(height: 20),

                    SectionLabel(isAr ? 'الحساب' : 'Account'),
                    BlocBuilder<AuthCubit, AuthState>(
                      builder: (context, authState) {
                        final isAuthenticated = authState is AuthAuthenticated;
                        return SettingsCard(isDark: isDark, children: [
                          SettingsTile(
                            icon: isAuthenticated ? Icons.person_rounded : Icons.login_rounded,
                            iconColor: AppColors.teal,
                            title: isAuthenticated 
                                ? (isAr ? 'الملف الشخصي' : 'Profile')
                                : (isAr ? 'تسجيل الدخول' : 'Sign In'),
                            subtitle: isAuthenticated
                                ? (isAr ? 'عرض وتعديل ملفك الشخصي' : 'View and edit your profile')
                                : (isAr ? 'سجل دخول لتتبع وِردك ومشاركته' : 'Sign in to track and share your wird'),
                            isDark: isDark,
                            onTap: () => context.push(isAuthenticated ? '/profile' : '/login'),
                          ),
                        ]);
                      },
                    ),
                    const SizedBox(height: 20),

                    SectionLabel(l10n.translate('general')),
                    SettingsCard(isDark: isDark, children: [
                      SettingsTile(
                        icon: Icons.language_rounded,
                        iconColor: AppColors.tealAccent,
                        title: l10n.translate('language'),
                        subtitle: isAr
                            ? l10n.translate('arabic')
                            : l10n.translate('english'),
                        isDark: isDark,
                        onTap: () => _showLanguagePicker(context),
                      ),
                      SettingsCardDivider(isDark: isDark),
                      SettingsTile(
                        icon: Icons.security_rounded,
                        iconColor: AppColors.amber,
                        title: l10n.translate('permissions'),
                        subtitle: state.permissionsGranted
                            ? l10n.translate('allGranted')
                            : l10n.translate('somePending'),
                        subtitleColor: state.permissionsGranted
                            ? AppColors.emerald
                            : AppColors.amber,
                        isDark: isDark,
                        onTap: () => context.push('/permissions'),
                      ),
                    ]),
                    const SizedBox(height: 20),

                    SectionLabel(l10n.translate('notifications')),
                    BlocBuilder<NotificationCubit, NotificationState>(
                      builder: (context, notifState) {
                        final s = notifState.prayerSettings;
                        final prayerCount = (s.fajrEnabled ? 1 : 0) +
                            (s.dhuhrEnabled ? 1 : 0) +
                            (s.asrEnabled ? 1 : 0) +
                            (s.maghribEnabled ? 1 : 0) +
                            (s.ishaEnabled ? 1 : 0);
                        return SettingsCard(isDark: isDark, children: [
                          SettingsTile(
                            icon: Icons.mosque_rounded,
                            iconColor: AppColors.teal,
                            title: l10n.translate('prayerNotifications'),
                            subtitle: '$prayerCount/5 prayers',
                            isDark: isDark,
                            onTap: () => _showPrayerNotificationSheet(context, isDark),
                          ),
                          SettingsCardDivider(isDark: isDark),
                          AdhkarNotificationTile(
                            type: AdhkarNotificationType.morning,
                            isDark: isDark,
                          ),
                          SettingsCardDivider(isDark: isDark),
                          AdhkarNotificationTile(
                            type: AdhkarNotificationType.evening,
                            isDark: isDark,
                          ),
                          SettingsCardDivider(isDark: isDark),
                          SleepTimeTile(isDark: isDark),
                          SettingsCardDivider(isDark: isDark),
                          SettingsTile(
                            icon: Icons.notifications_active_rounded,
                            iconColor: AppColors.sky,
                            title: isAr
                                ? 'اختبار الإشعار (بعد دقيقتين)'
                                : 'Test notification (in 2 minutes)',
                            subtitle: isAr
                                ? 'لتجربة إعدادات الإشعارات الحالية'
                                : 'Quickly test your current notification setup',
                            isDark: isDark,
                            onTap: () async {
                              final ok = await context
                                  .read<NotificationCubit>()
                                  .scheduleTestNotificationInTwoMinutes();
                              if (!context.mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    ok
                                        ? (isAr
                                            ? 'سيصلك إشعار تجريبي خلال دقيقتين'
                                            : 'Test notification scheduled in 2 minutes')
                                        : (isAr
                                            ? 'لم يتم منح صلاحية الإشعارات'
                                            : 'Notification permission not granted'),
                                  ),
                                ),
                              );
                            },
                          ),
                        ]);
                      },
                    ),
                    const SizedBox(height: 20),

                    SectionLabel(l10n.translate('about')),
                    SettingsCard(isDark: isDark, children: [
                      SettingsTile(
                        icon: Icons.info_outline_rounded,
                        iconColor: AppColors.indigo,
                        title: l10n.translate('appNameLabel'),
                        subtitle: l10n.translate('appName'),
                        isDark: isDark,
                        showChevron: false,
                      ),
                      SettingsCardDivider(isDark: isDark),
                      SettingsTile(
                        icon: Icons.verified_rounded,
                        iconColor: AppColors.emerald,
                        title: l10n.translate('appVersion'),
                        subtitle: '1.0.0',
                        isDark: isDark,
                        showChevron: false,
                      ),
                    ]),                    const SizedBox(height: 50),

                  ]),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  String _themeModeLabel(BuildContext context, ThemeMode mode) {
    final l10n = AppLocalizations.of(context);
    switch (mode) {
      case ThemeMode.light:
        return l10n.translate('light');
      case ThemeMode.dark:
        return l10n.translate('dark');
      case ThemeMode.system:
        return l10n.translate('systemDefault');
    }
  }

  String _reciterDisplayName(String id, bool isAr) {
    if (isAr) {
      return Reciters.displayNamesAr[id] ??
          Reciters.displayNames[id] ??
          id;
    }
    return Reciters.displayNames[id] ?? id;
  }

  void _showThemePicker(BuildContext context, ThemeMode current) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? AppColors.darkCard : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => BlocProvider.value(
        value: context.read<SettingsCubit>(),
        child: ThemePickerSheet(current: current, isDark: isDark),
      ),
    );
  }

  void _showLanguagePicker(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cubit = context.read<SettingsCubit>();
    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? AppColors.darkCard : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => BlocProvider.value(
        value: cubit,
        child: LanguagePickerSheet(
          current: cubit.state.locale,
          isDark: isDark,
        ),
      ),
    );
  }

  void _showPrayerNotificationSheet(BuildContext context, bool isDark) {
    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? AppColors.darkCard : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => BlocProvider.value(
        value: context.read<NotificationCubit>(),
        child: PrayerNotificationSheet(isDark: isDark),
      ),
    );
  }

}
