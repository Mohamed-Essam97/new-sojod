import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../cubit/home_cubit.dart';
import '../cubit/home_state.dart';
import '../widgets/home_header.dart';
import '../widgets/last_read_card.dart';
import '../widgets/prayer_hero_card.dart';
import '../widgets/quick_card.dart';
import '../widgets/upcoming_prayers_section.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<HomeCubit>(),
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  static String _greetingKey(AppLocalizations l10n) {
    final h = DateTime.now().hour;
    if (h < 12) return 'goodMorning';
    if (h < 17) return 'goodAfternoon';
    return 'goodEvening';
  }

  static String _getPrayerDisplayName(
      String key, DateTime? date, AppLocalizations l10n) {
    final d = date ?? DateTime.now();
    if (key == 'dhuhr' && d.weekday == DateTime.friday) {
      return l10n.translate('jumuah');
    }
    return l10n.translate(key);
  }

  static String _heroSubtitle(
    PrayerSelection? displayed,
    String? nextPrayerName,
    DateTime? nextPrayerDate,
    AppLocalizations l10n,
  ) {
    if (displayed == null) return '';
    final isNext = nextPrayerName != null &&
        displayed.key == nextPrayerName &&
        nextPrayerDate != null &&
        displayed.date.year == nextPrayerDate.year &&
        displayed.date.month == nextPrayerDate.month &&
        displayed.date.day == nextPrayerDate.day;
    final today = DateTime.now();
    final dateOnly = DateTime(today.year, today.month, today.day);
    final d = DateTime(displayed.date.year, displayed.date.month, displayed.date.day);
    final diff = d.difference(dateOnly).inDays;
    final dateLabel = diff == 0
        ? l10n.translate('today')
        : diff == 1
            ? l10n.translate('tomorrow')
            : DateFormat.E(l10n.locale.languageCode).format(displayed.date);
    if (isNext) {
      return '${l10n.translate('nextPrayer')} · $dateLabel';
    }
    final prayerName = _getPrayerDisplayName(displayed.key, displayed.date, l10n);
    final capped = prayerName.length > 1
        ? '${prayerName[0].toUpperCase()}${prayerName.substring(1)}'
        : prayerName;
    return '$capped · $dateLabel';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: AppColors.surface(context),
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: HomeHeader(
                  greeting: l10n.translate(_greetingKey(l10n)),
                  appName: l10n.translate('appName'),
                  locationName: state.locationName,
                  hijriDay: state.hijriDate?.hDay,
                  hijriMonth: state.hijriDate?.getLongMonthName(),
                  hijriYear: state.hijriDate?.hYear,
                ),
              ),
              if (state.displayedPrayer != null)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: PrayerHeroCard(
                      prayerName: _getPrayerDisplayName(
                          state.displayedPrayer!.key,
                          state.displayedPrayer!.date,
                          l10n),
                      time: state.displayedPrayer!.time,
                      countdown: state.countdown,
                      l10n: l10n,
                      subtitle: _heroSubtitle(
                        state.displayedPrayer,
                        state.nextPrayerName,
                        state.nextPrayerDate,
                        l10n,
                      ),
                    ),
                  ),
                ),
              if (state.upcomingPrayers.isNotEmpty)
                SliverToBoxAdapter(
                  child: UpcomingPrayersSection(
                    upcomingPrayers: state.upcomingPrayers,
                    nextPrayerName: state.nextPrayerName,
                    selectedPrayer: state.selectedPrayer,
                    onPrayerSelected: (p) =>
                        context.read<HomeCubit>().selectPrayer(p),
                    l10n: l10n,
                    isDark: isDark,
                  ),
                ),
              // const SliverToBoxAdapter(
              //   child: MoodSelectionCard(),
              // ),
              if (state.lastReadPage > 1)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                    child: LastReadCard(
                      page: state.lastReadPage,
                      l10n: l10n,
                      onTap: () => context.push(
                          '/quran/reader?page=${state.lastReadPage}'),
                    ),
                  ),
                ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
                  child: Text(
                    l10n.translate('quickAccess'),
                    style: TextStyle(
                      color: isDark
                          ? AppColors.textPrimaryDark
                          : AppColors.textPrimaryLight,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverGrid(
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 0.95,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => _buildQuickCard(context, l10n, index),
                    childCount: _quickAccessItemCount,
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          );
        },
      ),
    );
  }

  static const int _quickAccessItemCount = 6;

  QuickCard _buildQuickCard(
      BuildContext context, AppLocalizations l10n, int index) {
    final isAr = l10n.locale.languageCode == 'ar';
    final (icon, label, route, color) = _quickAccessData(index, l10n, isAr);
    return QuickCard(
      icon: icon,
      label: label,
      accentColor: color,
      onTap: () => context.push(route),
    );
  }

  static (IconData, String, String, Color) _quickAccessData(
      int index, AppLocalizations l10n, bool isAr) {
    switch (index) {
      case 0:
        return (
          Icons.task_alt_rounded,
          isAr ? 'وِردي' : 'My Wird',
          '/wird',
          AppColors.teal,
        );
      case 1:
        return (
          Icons.groups_rounded,
          isAr ? 'المجموعات' : 'Groups',
          '/groups',
          AppColors.violet,
        );
      case 2:
        return (
          Icons.menu_book_rounded,
          l10n.translate('readQuran'),
          '/quran',
          AppColors.emerald,
        );
      case 3:
        return (
          Icons.headphones_rounded,
          isAr ? 'استماع القرآن' : 'Quran Audio',
          '/quran-audio',
          AppColors.teal,
        );
      case 4:
        return (
          Icons.explore_rounded,
          l10n.translate('qiblaCompass'),
          '/qibla',
          AppColors.sky,
        );
      case 5:
        return (
          Icons.menu_book_rounded,
          l10n.translate('hadith'),
          '/hadith',
          AppColors.indigo,
        );
      default:
        return (Icons.help_outline, '', '/', AppColors.teal);
    }
  }
}
