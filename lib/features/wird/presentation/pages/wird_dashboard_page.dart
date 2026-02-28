import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../auth/presentation/cubit/auth_state.dart';
import '../cubit/wird_cubit.dart';
import '../cubit/wird_state.dart';
import '../widgets/create_wird_dialog.dart';
import '../widgets/wird_card.dart';

class WirdDashboardPage extends StatelessWidget {
  const WirdDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isAr = l10n.locale.languageCode == 'ar';

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0A1929) : Colors.grey[50],
      appBar: AppBar(
        title: Text(isAr ? 'وِردي اليومي' : 'My Daily Wird'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, authState) {
          if (authState is! AuthAuthenticated) {
            return _SignInRequiredView(isAr: isAr, isDark: isDark);
          }

          final userId = authState.user.uid;

          return BlocBuilder<WirdCubit, WirdState>(
            builder: (context, wirdState) {
              if (wirdState is WirdLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (wirdState is WirdEmpty) {
                return _EmptyWirdView(
                  isAr: isAr,
                  isDark: isDark,
                  onCreatePressed: () => _showCreateWirdDialog(context, userId),
                );
              }

              if (wirdState is WirdLoaded) {
                final wird = wirdState.wird;

                return RefreshIndicator(
                  onRefresh: () async {
                    context.read<WirdCubit>().loadTodayWird(userId);
                  },
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _TodayHeader(isAr: isAr, isDark: isDark),
                        const SizedBox(height: 20),
                        WirdCard(
                          title: isAr ? 'قراءة القرآن' : 'Quran Reading',
                          icon: Icons.menu_book_rounded,
                          iconColor: AppColors.teal,
                          progress: wird.quranProgress,
                          currentValue: wird.quranProgressPages,
                          targetValue: wird.quranTargetPages,
                          unit: isAr ? 'صفحة' : 'pages',
                          isDark: isDark,
                          onIncrement: () {
                            final newProgress = wird.quranProgressPages + 1;
                            context.read<WirdCubit>().updateQuranProgress(newProgress);
                          },
                          onDecrement: () {
                            final newProgress = wird.quranProgressPages - 1;
                            if (newProgress >= 0) {
                              context.read<WirdCubit>().updateQuranProgress(newProgress);
                            }
                          },
                        ),
                        const SizedBox(height: 16),
                        WirdCard(
                          title: isAr ? 'الأذكار' : 'Adhkar',
                          icon: Icons.wb_twilight_rounded,
                          iconColor: AppColors.amber,
                          isDark: isDark,
                          children: [
                            _AdhkarCheckbox(
                              title: isAr ? 'أذكار الصباح' : 'Morning Adhkar',
                              isChecked: wird.adhkarMorningDone,
                              onChanged: (val) => context.read<WirdCubit>().toggleAdhkarMorning(),
                              isDark: isDark,
                            ),
                            _AdhkarCheckbox(
                              title: isAr ? 'أذكار المساء' : 'Evening Adhkar',
                              isChecked: wird.adhkarEveningDone,
                              onChanged: (val) => context.read<WirdCubit>().toggleAdhkarEvening(),
                              isDark: isDark,
                            ),
                            _AdhkarCheckbox(
                              title: isAr ? 'أذكار النوم' : 'Sleep Dhikr',
                              isChecked: wird.sleepDhikrDone,
                              onChanged: (val) => context.read<WirdCubit>().toggleSleepDhikr(),
                              isDark: isDark,
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        WirdCard(
                          title: isAr ? 'التسبيح' : 'Tasbeeh',
                          icon: Icons.star_rounded,
                          iconColor: AppColors.violet,
                          progress: wird.tasbeehProgressPercent,
                          currentValue: wird.tasbeehProgress,
                          targetValue: wird.tasbeehTarget,
                          unit: isAr ? 'مرة' : 'times',
                          isDark: isDark,
                          onIncrement: () {
                            final newProgress = wird.tasbeehProgress + 1;
                            context.read<WirdCubit>().updateTasbeehProgress(newProgress);
                          },
                          onDecrement: () {
                            final newProgress = wird.tasbeehProgress - 1;
                            if (newProgress >= 0) {
                              context.read<WirdCubit>().updateTasbeehProgress(newProgress);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                );
              }

              if (wirdState is WirdError) {
                return Center(
                  child: Text(
                    isAr ? 'حدث خطأ: ${wirdState.message}' : 'Error: ${wirdState.message}',
                  ),
                );
              }

              return const SizedBox.shrink();
            },
          );
        },
      ),
    );
  }

  void _showCreateWirdDialog(BuildContext context, String userId) {
    showDialog(
      context: context,
      builder: (dialogContext) => CreateWirdDialog(
        onCreateWird: (quranPages, tasbeehCount) {
          context.read<WirdCubit>().createWird(
                userId: userId,
                quranTargetPages: quranPages,
                tasbeehTarget: tasbeehCount,
              );
        },
      ),
    );
  }
}

class _TodayHeader extends StatelessWidget {
  const _TodayHeader({required this.isAr, required this.isDark});

  final bool isAr;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final dateStr = isAr
        ? '${now.day}/${now.month}/${now.year}'
        : '${now.day}/${now.month}/${now.year}';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.teal, AppColors.tealDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.today_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isAr ? 'اليوم' : 'Today',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
                Text(
                  dateStr,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
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

class _EmptyWirdView extends StatelessWidget {
  const _EmptyWirdView({
    required this.isAr,
    required this.isDark,
    required this.onCreatePressed,
  });

  final bool isAr;
  final bool isDark;
  final VoidCallback onCreatePressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.teal.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.book_outlined,
                size: 60,
                color: AppColors.teal,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              isAr ? 'لم تقم بإنشاء ورد بعد' : 'No wird created yet',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              isAr
                  ? 'ابدأ رحلتك الروحانية بإنشاء وِرد يومي'
                  : 'Start your spiritual journey by creating a daily wird',
              style: TextStyle(
                fontSize: 14,
                color: isDark ? Colors.white70 : Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: onCreatePressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.teal,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.add_circle_outline),
                  const SizedBox(width: 8),
                  Text(
                    isAr ? 'إنشاء وِرد' : 'Create Wird',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AdhkarCheckbox extends StatelessWidget {
  const _AdhkarCheckbox({
    required this.title,
    required this.isChecked,
    required this.onChanged,
    required this.isDark,
  });

  final String title;
  final bool isChecked;
  final ValueChanged<bool?> onChanged;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(
            width: 28,
            height: 28,
            child: Checkbox(
              value: isChecked,
              onChanged: onChanged,
              activeColor: AppColors.teal,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 15,
              color: isDark ? Colors.white : Colors.black87,
              decoration: isChecked ? TextDecoration.lineThrough : null,
            ),
          ),
        ],
      ),
    );
  }
}

class _SignInRequiredView extends StatelessWidget {
  const _SignInRequiredView({
    required this.isAr,
    required this.isDark,
  });

  final bool isAr;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.teal.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.lock_outline,
                size: 60,
                color: AppColors.teal,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              isAr ? 'تسجيل الدخول مطلوب' : 'Sign In Required',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              isAr
                  ? 'سجل دخول لتتبع وِردك اليومي ومشاركته مع أصدقائك'
                  : 'Sign in to track and share your daily wird',
              style: TextStyle(
                fontSize: 14,
                color: isDark ? Colors.white70 : Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => context.push('/login'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.teal,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.login_rounded),
                  const SizedBox(width: 8),
                  Text(
                    isAr ? 'تسجيل الدخول' : 'Sign In',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
