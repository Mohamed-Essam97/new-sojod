import 'package:al_mumin/core/assets/app_svgs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/card_decoration_builder.dart';
import '../../../../core/localization/app_localizations.dart';
import '../cubit/home_cubit.dart';
import '../cubit/home_state.dart';

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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final subTextColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;

    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppConstants.paddingScreenHorizontal,
                      vertical: AppConstants.paddingScreenVertical,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.mosque, color: AppColors.teal, size: 28),
                                  const SizedBox(width: 8),
                                  Text(
                                    l10n.translate('appName'),
                                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                          color: textColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              if (state.locationName.isNotEmpty)
                                Row(
                                  children: [
                                    SvgPicture.asset(AppSvgs.location, width: 16, height: 16, colorFilter: ColorFilter.mode(AppColors.greyDark, BlendMode.srcIn)),
                                    const SizedBox(width: 4),
                                    Text(
                                      state.locationName,
                                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                            color: subTextColor,
                                          ),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                        if (state.hijriDate != null)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '${state.hijriDate!.hDay} ${state.hijriDate!.getLongMonthName()}',
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      color: AppColors.grey,
                                    ),
                              ),
                              Text(
                                '${state.hijriDate!.hYear} AH',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: AppColors.grey,
                                    ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
                if (state.nextPrayer != null && state.nextPrayerName != null)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppConstants.paddingScreenHorizontal,
                      ),
                      child: _NextPrayerTodayCard(
                        name: state.nextPrayerName!,
                        time: state.nextPrayer!,
                        countdown: state.countdown,
                        l10n: l10n,
                        isDark: isDark,
                      ),
                    ),
                  ),
                if (state.upcomingPrayers.isNotEmpty) ...[
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(
                        AppConstants.paddingScreenHorizontal,
                        24,
                        AppConstants.paddingScreenHorizontal,
                        12,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            l10n.translate('upcomingPrayers'),
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: textColor,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          GestureDetector(
                            onTap: () => context.go('/prayer'),
                            child: Text(
                              l10n.translate('viewMore'),
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: AppColors.teal,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 120,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppConstants.paddingScreenHorizontal,
                        ),
                        itemCount: state.upcomingPrayers.length,
                        itemBuilder: (context, i) {
                          final p = state.upcomingPrayers[i];
                          final isNext = p.key == state.nextPrayerName;
                          final displayName = _getPrayerDisplayName(p.key, l10n);
                          return _UpcomingPrayerCard(
                            name: displayName,
                            time: p.time,
                            isNext: isNext,
                            l10n: l10n,
                            isDark: isDark,
                          );
                        },
                      ),
                    ),
                  ),
                ],
                const SliverToBoxAdapter(child: SizedBox(height: 24)),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppConstants.paddingScreenHorizontal,
                    ),
                    child:                           Text(
                            'Quick Access',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: textColor,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 12)),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.paddingScreenHorizontal,
                  ),
                  sliver: SliverGrid(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 0.95,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    delegate: SliverChildListDelegate([
                      _QuickAccessCard(
                        icon: Icons.menu_book,
                        label: l10n.translate('readQuran'),
                        onTap: () => context.go('/quran'),
                        textColor: textColor,
                      ),
                      _QuickAccessCard(
                        icon: Icons.flag_outlined,
                        label: l10n.translate('quranCompletionPlan'),
                        onTap: () => context.go('/quran'),
                        textColor: textColor,
                      ),
                      _QuickAccessCard(
                        icon: Icons.explore,
                        label: l10n.translate('qiblaCompass'),
                        onTap: () => context.go('/qibla'),
                        textColor: textColor,
                      ),
                      _QuickAccessCard(
                        icon: Icons.favorite_border,
                        label: l10n.translate('duaAdhkar'),
                        onTap: () => context.go('/adhkar'),
                        textColor: textColor,
                      ),
                      _QuickAccessCard(
                        icon: Icons.mosque,
                        label: l10n.translate('mosqueFinder'),
                        onTap: () => context.go('/mosque'),
                        textColor: textColor,
                      ),
                      _QuickAccessCard(
                        icon: Icons.touch_app,
                        label: l10n.translate('tasbeehCounter'),
                        onTap: () => context.go('/tasbeeh'),
                        textColor: textColor,
                      ),
                    ]),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 40)),
              ],
            );
          },
        ),
      ),
    );
  }

  String _getPrayerDisplayName(String key, AppLocalizations l10n) {
    final friday = DateTime.now().weekday == DateTime.friday;
    if (key == 'dhuhr' && friday) return 'Jummah';
    return l10n.translate(key);
  }
}

class _NextPrayerTodayCard extends StatelessWidget {
  final String name;
  final DateTime time;
  final Duration? countdown;
  final AppLocalizations l10n;
  final bool isDark;

  const _NextPrayerTodayCard({
    required this.name,
    required this.time,
    this.countdown,
    required this.l10n,
    this.isDark = true,
  });

  @override
  Widget build(BuildContext context) {
    final hours = countdown?.inHours ?? 0;
    final mins = ((countdown?.inMinutes ?? 0) % 60).toString().padLeft(2, '0');
    final secs = ((countdown?.inSeconds ?? 0) % 60).toString().padLeft(2, '0');
    final timeStr = DateFormat.jm().format(time);
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingCardLarge),
      decoration: CardDecorationBuilder.buildCardShadowDecoration(
        colorScheme: colorScheme,
        borderRadius: 16,
        surfaceColor: AppColors.tealDark.withValues(alpha: 0.8),
        border: Border.all(color: AppColors.teal.withValues(alpha: 0.3)),
        blurRadius: 12,
        shadowOpacity: 0.08,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: CardDecorationBuilder.buildCardShadowDecoration(
                    colorScheme: colorScheme,
                    borderRadius: 20,
                    surfaceColor: AppColors.grey.withValues(alpha: 0.3),
                    blurRadius: 8,
                    shadowOpacity: 0.05,
                  ),
                  child: Text(
                    '${l10n.translate('nextPrayer')} • ${l10n.translate('today')}',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.greyLight,
                        ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  name.substring(0, 1).toUpperCase() + name.substring(1),
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: AppColors.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  timeStr,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.onSurfaceMuted,
                      ),
                ),
              ],
            ),
          ),
          if (countdown != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: CardDecorationBuilder.buildCardShadowDecoration(
                colorScheme: colorScheme,
                borderRadius: 12,
                surfaceColor: AppColors.teal,
                blurRadius: 12,
                shadowOpacity: 0.08,
              ),
              child: Column(
                children: [
                  Text(
                    '$hours:$mins:$secs',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppColors.onSurface,
                          fontWeight: FontWeight.bold,
                          fontFeatures: [const FontFeature.tabularFigures()],
                        ),
                  ),
                  Text(
                    l10n.translate('remaining'),
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.onSurfaceMuted,
                        ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _UpcomingPrayerCard extends StatelessWidget {
  final String name;
  final DateTime time;
  final bool isNext;
  final AppLocalizations l10n;
  final bool isDark;

  const _UpcomingPrayerCard({
    required this.name,
    required this.time,
    required this.isNext,
    required this.l10n,
    this.isDark = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;
    final timeStr = DateFormat.jm().format(time);

    return Container(
      width: 100,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(AppConstants.paddingCard),
      decoration: CardDecorationBuilder.buildCardShadowDecoration(
        colorScheme: colorScheme,
        borderRadius: 12,
        surfaceColor: isNext ? AppColors.teal : (isDark ? AppColors.darkCard : AppColors.lightCard),
        border: isNext ? null : Border.all(color: AppColors.borderMuted),
        blurRadius: 12,
        shadowOpacity: 0.06,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                name,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: isNext ? AppColors.onSurface : AppColors.textPrimaryLight,
                      fontWeight: FontWeight.w600,
                    ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Icon(Icons.schedule, size: 14, color: isNext ? AppColors.onSurfaceMuted : AppColors.greyDark),
            ],
          ),
          Text(
            timeStr,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: isNext ? AppColors.onSurfaceMuted : AppColors.grey,
                ),
          ),
        ],
      ),
    );
  }
}

class _QuickAccessCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color textColor;

  const _QuickAccessCard({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;
    final cardColor = isDark ? AppColors.darkCard : AppColors.cardLightTranslucent;

    return Container(
      decoration: CardDecorationBuilder.buildCardShadowDecoration(
        colorScheme: colorScheme,
        surfaceColor: cardColor,
      ),
      clipBehavior: Clip.antiAlias,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.paddingCard),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 26, color: AppColors.teal),
                const SizedBox(height: 6),
                Flexible(
                  child: Text(
                    label,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: textColor,
                          fontSize: 11,
                        ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
