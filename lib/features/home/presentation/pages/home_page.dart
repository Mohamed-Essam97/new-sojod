import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../cubit/home_cubit.dart';
import '../cubit/home_state.dart';
import '../widgets/home_header.dart';
import '../widgets/last_read_card.dart';
import '../widgets/prayer_hero_card.dart';
import '../widgets/prayer_pill.dart';
import '../widgets/quick_card.dart';

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

  static String _getPrayerDisplayName(String key, AppLocalizations l10n) {
    if (key == 'dhuhr' && DateTime.now().weekday == DateTime.friday) {
      return l10n.translate('jumuah');
    }
    return l10n.translate(key);
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
              if (state.nextPrayer != null && state.nextPrayerName != null)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: PrayerHeroCard(
                      prayerName: _getPrayerDisplayName(
                          state.nextPrayerName!, l10n),
                      time: state.nextPrayer!,
                      countdown: state.countdown,
                      l10n: l10n,
                    ),
                  ),
                ),
              if (state.upcomingPrayers.isNotEmpty) ...[
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          l10n.translate('upcomingPrayers'),
                          style: TextStyle(
                            color: isDark
                                ? AppColors.textPrimaryDark
                                : AppColors.textPrimaryLight,
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => context.push('/prayer'),
                          child: Text(
                            l10n.translate('seeAll'),
                            style: const TextStyle(
                              color: AppColors.teal,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 104,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: state.upcomingPrayers.length,
                      itemBuilder: (context, i) {
                        final p = state.upcomingPrayers[i];
                        final isNext = p.key == state.nextPrayerName;
                        return PrayerPill(
                          name: _getPrayerDisplayName(p.key, l10n),
                          time: p.time,
                          isNext: isNext,
                        );
                      },
                    ),
                  ),
                ),
              ],
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
                  delegate: SliverChildListDelegate(
                    _quickItems(context, l10n),
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

  List<Widget> _quickItems(
      BuildContext context, AppLocalizations l10n) {
    final items = [
      (
        icon: Icons.menu_book_rounded,
        label: l10n.translate('readQuran'),
        route: '/quran',
        color: AppColors.emerald,
      ),
      (
        icon: Icons.explore_rounded,
        label: l10n.translate('qiblaCompass'),
        route: '/qibla',
        color: AppColors.sky,
      ),
      (
        icon: Icons.favorite_rounded,
        label: l10n.translate('duaAdhkar'),
        route: '/adhkar',
        color: AppColors.rose,
      ),
      (
        icon: Icons.mosque_rounded,
        label: l10n.translate('mosqueFinder'),
        route: '/mosque',
        color: AppColors.violet,
      ),
      (
        icon: Icons.repeat_rounded,
        label: l10n.translate('tasbeehCounter'),
        route: '/tasbeeh',
        color: AppColors.amber,
      ),
      (
        icon: Icons.flag_rounded,
        label: l10n.translate('quranCompletionPlan'),
        route: '/quran',
        color: AppColors.teal,
      ),
    ];

    return items
        .map((e) => QuickCard(
              icon: e.icon,
              label: e.label,
              accentColor: e.color,
              onTap: () => context.push(e.route),
            ))
        .toList();
  }
}
