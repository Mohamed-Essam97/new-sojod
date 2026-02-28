import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../auth/presentation/cubit/auth_state.dart';
import '../../domain/entities/wird_entity.dart';
import '../cubit/wird_cubit.dart';
import '../cubit/wird_state.dart';
import '../widgets/create_wird_dialog.dart';

class WirdDashboardPage extends StatefulWidget {
  const WirdDashboardPage({super.key});

  @override
  State<WirdDashboardPage> createState() => _WirdDashboardPageState();
}

class _WirdDashboardPageState extends State<WirdDashboardPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _animController.forward();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authState = context.read<AuthCubit>().state;
      if (authState is AuthAuthenticated) {
        context.read<WirdCubit>().watchTodayWirdUpdates(authState.user.uid);
      }
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isAr = l10n.locale.languageCode == 'ar';

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0A1929) : const Color(0xFFF0F4F8),
      body: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, authState) {
          if (authState is! AuthAuthenticated) {
            return _SignInRequiredView(isAr: isAr, isDark: isDark);
          }

          final userId = authState.user.uid;
          final rawName = authState.user.displayName;
          final userName = rawName.isNotEmpty ? rawName.split(' ').first : '';

          return BlocBuilder<WirdCubit, WirdState>(
            builder: (context, wirdState) {
              if (wirdState is WirdInitial || wirdState is WirdLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (wirdState is WirdEmpty) {
                return _EmptyWirdView(
                  isAr: isAr,
                  isDark: isDark,
                  userName: userName,
                  fadeAnim: _fadeAnim,
                  onCreatePressed: () => _showCreateWirdDialog(context, userId),
                );
              }

              if (wirdState is WirdLoaded) {
                return FadeTransition(
                  opacity: _fadeAnim,
                  child: _WirdLoadedView(
                    wird: wirdState.wird,
                    isAr: isAr,
                    isDark: isDark,
                    userName: userName,
                    userId: userId,
                  ),
                );
              }

              if (wirdState is WirdError) {
                return Center(
                  child: Text(
                    isAr
                        ? 'حدث خطأ: ${wirdState.message}'
                        : 'Error: ${wirdState.message}',
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

// ─────────────────────────────────────────────────
// Loaded View
// ─────────────────────────────────────────────────
class _WirdLoadedView extends StatelessWidget {
  const _WirdLoadedView({
    required this.wird,
    required this.isAr,
    required this.isDark,
    required this.userName,
    required this.userId,
  });

  final WirdEntity wird;
  final bool isAr;
  final bool isDark;
  final String userName;
  final String userId;

  double get _overallProgress {
    int total = 3; // 3 adhkar items always counted
    int done = 0;
    if (wird.adhkarMorningDone) done++;
    if (wird.adhkarEveningDone) done++;
    if (wird.sleepDhikrDone) done++;
    if (wird.quranTargetPages > 0) {
      total++;
      if (wird.isQuranComplete) done++;
    }
    if (wird.tasbeehTarget > 0) {
      total++;
      if (wird.isTasbeehComplete) done++;
    }
    return total > 0 ? done / total : 0;
  }

  @override
  Widget build(BuildContext context) {
    final progress = _overallProgress;
    final isComplete = progress >= 1.0;

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        // ── Gradient header ─────────────────────────────────
        SliverAppBar(
          expandedHeight: 220,
          pinned: true,
          stretch: true,
          backgroundColor: AppColors.tealDark,
          flexibleSpace: FlexibleSpaceBar(
            stretchModes: const [StretchMode.zoomBackground],
            background: _WirdHeader(
              isAr: isAr,
              isDark: isDark,
              userName: userName,
              progress: progress,
              isComplete: isComplete,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.edit_outlined, color: Colors.white),
              tooltip: isAr ? 'تعديل الأهداف' : 'Edit targets',
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => CreateWirdDialog(
                    initialQuranPages: wird.quranTargetPages,
                    initialTasbeehCount: wird.tasbeehTarget,
                    onCreateWird: (quranPages, tasbeehCount) {
                      context.read<WirdCubit>().createWird(
                            userId: userId,
                            quranTargetPages: quranPages,
                            tasbeehTarget: tasbeehCount,
                          );
                    },
                  ),
                );
              },
            ),
          ],
        ),

        // ── Refresh + content ────────────────────────────────
        SliverToBoxAdapter(
          child: RefreshIndicator(
            onRefresh: () async =>
                context.read<WirdCubit>().loadTodayWird(userId),
            child: Column(
              children: [
                if (isComplete)
                  _CompletionBanner(isAr: isAr, isDark: isDark),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      // Quran Card
                      if (wird.quranTargetPages > 0)
                        _QuranWirdCard(wird: wird, isAr: isAr, isDark: isDark),
                      if (wird.quranTargetPages > 0)
                        const SizedBox(height: 14),

                      // Adhkar Card
                      _AdhkarWirdCard(wird: wird, isAr: isAr, isDark: isDark),
                      const SizedBox(height: 14),

                      // Tasbeeh Card
                      if (wird.tasbeehTarget > 0)
                        _TasbeehWirdCard(
                            wird: wird, isAr: isAr, isDark: isDark),
                      if (wird.tasbeehTarget > 0)
                        const SizedBox(height: 14),

                      const SizedBox(height: 80),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────
// Header with circular progress
// ─────────────────────────────────────────────────
class _WirdHeader extends StatelessWidget {
  const _WirdHeader({
    required this.isAr,
    required this.isDark,
    required this.userName,
    required this.progress,
    required this.isComplete,
  });

  final bool isAr;
  final bool isDark;
  final String userName;
  final double progress;
  final bool isComplete;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final weekdays = isAr
        ? ['الأحد', 'الاثنين', 'الثلاثاء', 'الأربعاء', 'الخميس', 'الجمعة', 'السبت']
        : ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    final months = isAr
        ? ['يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو', 'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر']
        : ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final dayName = weekdays[now.weekday % 7];
    final dateStr = isAr
        ? '$dayName، ${now.day} ${months[now.month - 1]}'
        : '$dayName, ${months[now.month - 1]} ${now.day}';

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF004D40), Color(0xFF00897B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Date & greeting
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      isAr
                          ? (userName.isNotEmpty ? 'مرحباً، $userName' : 'مرحباً')
                          : (userName.isNotEmpty ? 'Hello, $userName' : 'Hello'),
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isAr ? 'وِردي اليومي' : 'My Daily Wird',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.calendar_today_outlined,
                            size: 14, color: Colors.white70),
                        const SizedBox(width: 5),
                        Text(
                          dateStr,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Circular progress ring
              _CircularProgressRing(
                progress: progress,
                isComplete: isComplete,
                isAr: isAr,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────
// Circular progress ring
// ─────────────────────────────────────────────────
class _CircularProgressRing extends StatelessWidget {
  const _CircularProgressRing({
    required this.progress,
    required this.isComplete,
    required this.isAr,
  });

  final double progress;
  final bool isComplete;
  final bool isAr;

  @override
  Widget build(BuildContext context) {
    final pct = (progress * 100).toInt();
    return SizedBox(
      width: 90,
      height: 90,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: const Size(90, 90),
            painter: _RingPainter(
              progress: progress,
              color: isComplete ? Colors.amber : Colors.white,
              trackColor: Colors.white.withValues(alpha: 0.2),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$pct%',
                style: TextStyle(
                  color: isComplete ? Colors.amber : Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (isComplete)
                const Text('✓',
                    style: TextStyle(color: Colors.amber, fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  const _RingPainter({
    required this.progress,
    required this.color,
    required this.trackColor,
  });

  final double progress;
  final Color color;
  final Color trackColor;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - 10) / 2;
    const strokeWidth = 7.0;

    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final progressPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, trackPaint);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(_RingPainter old) =>
      old.progress != progress || old.color != color;
}

// ─────────────────────────────────────────────────
// Completion banner
// ─────────────────────────────────────────────────
class _CompletionBanner extends StatelessWidget {
  const _CompletionBanner({required this.isAr, required this.isDark});

  final bool isAr;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFF59E0B), Color(0xFFF97316)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.amber.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          const Text('🎉', style: TextStyle(fontSize: 28)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isAr ? 'أتممت وِردك اليوم!' : 'Wird Complete Today!',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  isAr
                      ? 'بارك الله فيك وتقبل منك'
                      : 'May Allah accept your deeds',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
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

// ─────────────────────────────────────────────────
// Quran Wird Card
// ─────────────────────────────────────────────────
class _QuranWirdCard extends StatelessWidget {
  const _QuranWirdCard({
    required this.wird,
    required this.isAr,
    required this.isDark,
  });

  final WirdEntity wird;
  final bool isAr;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final isComplete = wird.isQuranComplete;
    final progress = wird.quranProgress;

    return _WirdCard(
      isDark: isDark,
      isComplete: isComplete,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _CardIcon(
                icon: Icons.menu_book_rounded,
                color: AppColors.teal,
                isComplete: isComplete,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  isAr ? 'قراءة القرآن' : 'Quran Reading',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
              ),
              if (isComplete)
                _CompleteBadge(isAr: isAr),
            ],
          ),
          const SizedBox(height: 16),
          // Progress stats
          Row(
            children: [
              _StatChip(
                label: '${wird.quranProgressPages}',
                sublabel: isAr ? 'صفحة' : 'pages',
                color: AppColors.teal,
                isDark: isDark,
              ),
              const SizedBox(width: 8),
              const Text('/', style: TextStyle(color: Colors.grey, fontSize: 18)),
              const SizedBox(width: 8),
              _StatChip(
                label: '${wird.quranTargetPages}',
                sublabel: isAr ? 'هدف' : 'target',
                color: Colors.grey,
                isDark: isDark,
              ),
              const Spacer(),
              Text(
                '${(progress * 100).toInt()}%',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: isComplete ? AppColors.teal : AppColors.teal,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor:
                  isDark ? Colors.grey[800] : Colors.grey[200],
              valueColor:
                  AlwaysStoppedAnimation<Color>(AppColors.teal),
            ),
          ),
          const SizedBox(height: 14),
          // Controls row
          Row(
            children: [
              // Open Quran button
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => context.push('/quran/reader'),
                  icon: const Icon(Icons.import_contacts_rounded, size: 18),
                  label: Text(isAr ? 'افتح القرآن' : 'Open Quran'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.teal,
                    side: const BorderSide(color: AppColors.teal),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // Manual counter
              _CounterButton(
                icon: Icons.remove,
                color: AppColors.teal,
                onPressed: () {
                  final newProgress = wird.quranProgressPages - 1;
                  if (newProgress >= 0) {
                    context.read<WirdCubit>().updateQuranProgress(newProgress);
                  }
                },
              ),
              const SizedBox(width: 8),
              _CounterButton(
                icon: Icons.add,
                color: AppColors.teal,
                onPressed: () {
                  context
                      .read<WirdCubit>()
                      .updateQuranProgress(wird.quranProgressPages + 1);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────
// Adhkar Wird Card
// ─────────────────────────────────────────────────
class _AdhkarWirdCard extends StatelessWidget {
  const _AdhkarWirdCard({
    required this.wird,
    required this.isAr,
    required this.isDark,
  });

  final WirdEntity wird;
  final bool isAr;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final doneCount = (wird.adhkarMorningDone ? 1 : 0) +
        (wird.adhkarEveningDone ? 1 : 0) +
        (wird.sleepDhikrDone ? 1 : 0);
    final isComplete = doneCount == 3;

    return _WirdCard(
      isDark: isDark,
      isComplete: isComplete,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _CardIcon(
                icon: Icons.wb_twilight_rounded,
                color: AppColors.amber,
                isComplete: isComplete,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  isAr ? 'الأذكار' : 'Adhkar',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
              ),
              if (isComplete) _CompleteBadge(isAr: isAr),
              Text(
                '$doneCount/3',
                style: TextStyle(
                  color: isDark ? Colors.white54 : Colors.grey[500],
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _AdhkarItem(
            icon: Icons.wb_sunny_outlined,
            label: isAr ? 'أذكار الصباح' : 'Morning Adhkar',
            isChecked: wird.adhkarMorningDone,
            color: const Color(0xFFF97316),
            isDark: isDark,
            onTap: () => context.read<WirdCubit>().toggleAdhkarMorning(),
            onNavigate: () => context.push('/adhkar'),
          ),
          _AdhkarItem(
            icon: Icons.nights_stay_outlined,
            label: isAr ? 'أذكار المساء' : 'Evening Adhkar',
            isChecked: wird.adhkarEveningDone,
            color: AppColors.indigo,
            isDark: isDark,
            onTap: () => context.read<WirdCubit>().toggleAdhkarEvening(),
            onNavigate: () => context.push('/adhkar'),
          ),
          _AdhkarItem(
            icon: Icons.bedtime_outlined,
            label: isAr ? 'أذكار النوم' : 'Sleep Dhikr',
            isChecked: wird.sleepDhikrDone,
            color: AppColors.violet,
            isDark: isDark,
            onTap: () => context.read<WirdCubit>().toggleSleepDhikr(),
            onNavigate: () => context.push('/adhkar'),
            isLast: true,
          ),
        ],
      ),
    );
  }
}

class _AdhkarItem extends StatelessWidget {
  const _AdhkarItem({
    required this.icon,
    required this.label,
    required this.isChecked,
    required this.color,
    required this.isDark,
    required this.onTap,
    required this.onNavigate,
    this.isLast = false,
  });

  final IconData icon;
  final String label;
  final bool isChecked;
  final Color color;
  final bool isDark;
  final VoidCallback onTap;
  final VoidCallback onNavigate;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
            child: Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: isChecked
                        ? color.withValues(alpha: 0.15)
                        : (isDark ? Colors.grey[800] : Colors.grey[100]),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    isChecked ? Icons.check_rounded : icon,
                    color: isChecked ? color : (isDark ? Colors.white54 : Colors.grey[400]),
                    size: 18,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 15,
                      color: isChecked
                          ? (isDark ? Colors.white54 : Colors.grey[400])
                          : (isDark ? Colors.white : Colors.black87),
                      decoration: isChecked ? TextDecoration.lineThrough : null,
                    ),
                  ),
                ),
                // Navigate to adhkar button
                IconButton(
                  icon: Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 14,
                    color: isDark ? Colors.white38 : Colors.grey[400],
                  ),
                  onPressed: onNavigate,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                ),
              ],
            ),
          ),
        ),
        if (!isLast)
          Divider(
            height: 1,
            color: isDark ? Colors.white12 : Colors.grey[100],
          ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────
// Tasbeeh Wird Card
// ─────────────────────────────────────────────────
class _TasbeehWirdCard extends StatelessWidget {
  const _TasbeehWirdCard({
    required this.wird,
    required this.isAr,
    required this.isDark,
  });

  final WirdEntity wird;
  final bool isAr;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final isComplete = wird.isTasbeehComplete;
    final progress = wird.tasbeehProgressPercent;

    return _WirdCard(
      isDark: isDark,
      isComplete: isComplete,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _CardIcon(
                icon: Icons.star_rounded,
                color: AppColors.violet,
                isComplete: isComplete,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  isAr ? 'التسبيح' : 'Tasbeeh',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
              ),
              if (isComplete) _CompleteBadge(isAr: isAr),
            ],
          ),
          const SizedBox(height: 16),
          // Big count display
          Center(
            child: Column(
              children: [
                Text(
                  '${wird.tasbeehProgress}',
                  style: TextStyle(
                    fontSize: 52,
                    fontWeight: FontWeight.bold,
                    color: isComplete ? AppColors.violet : (isDark ? Colors.white : Colors.black87),
                  ),
                ),
                Text(
                  isAr
                      ? 'من ${wird.tasbeehTarget} مرة'
                      : 'of ${wird.tasbeehTarget} times',
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? Colors.white54 : Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: isDark ? Colors.grey[800] : Colors.grey[200],
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.violet),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _CounterButton(
                icon: Icons.remove,
                color: AppColors.violet,
                size: 52,
                iconSize: 28,
                onPressed: () {
                  final newProgress = wird.tasbeehProgress - 1;
                  if (newProgress >= 0) {
                    context.read<WirdCubit>().updateTasbeehProgress(newProgress);
                  }
                },
              ),
              const SizedBox(width: 20),
              _CounterButton(
                icon: Icons.add,
                color: AppColors.violet,
                size: 52,
                iconSize: 28,
                onPressed: () {
                  context
                      .read<WirdCubit>()
                      .updateTasbeehProgress(wird.tasbeehProgress + 1);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────
// Shared sub-widgets
// ─────────────────────────────────────────────────
class _WirdCard extends StatelessWidget {
  const _WirdCard({
    required this.isDark,
    required this.isComplete,
    required this.child,
  });

  final bool isDark;
  final bool isComplete;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A2332) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: isComplete
            ? Border.all(color: AppColors.teal.withValues(alpha: 0.5), width: 1.5)
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _CardIcon extends StatelessWidget {
  const _CardIcon({
    required this.icon,
    required this.color,
    required this.isComplete,
  });

  final IconData icon;
  final Color color;
  final bool isComplete;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: 46,
      height: 46,
      decoration: BoxDecoration(
        color: isComplete
            ? color.withValues(alpha: 0.2)
            : color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(13),
      ),
      child: Icon(
        isComplete ? Icons.check_circle_rounded : icon,
        color: color,
        size: 24,
      ),
    );
  }
}

class _CompleteBadge extends StatelessWidget {
  const _CompleteBadge({required this.isAr});
  final bool isAr;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.teal.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        isAr ? 'مكتمل ✓' : 'Done ✓',
        style: const TextStyle(
          color: AppColors.teal,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({
    required this.label,
    required this.sublabel,
    required this.color,
    required this.isDark,
  });

  final String label;
  final String sublabel;
  final Color color;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: color == Colors.grey
                ? (isDark ? Colors.white54 : Colors.grey[400])
                : color,
          ),
        ),
        Text(
          sublabel,
          style: TextStyle(
            fontSize: 11,
            color: isDark ? Colors.white38 : Colors.grey[400],
          ),
        ),
      ],
    );
  }
}

class _CounterButton extends StatelessWidget {
  const _CounterButton({
    required this.icon,
    required this.color,
    required this.onPressed,
    this.size = 44,
    this.iconSize = 22,
  });

  final IconData icon;
  final Color color;
  final VoidCallback onPressed;
  final double size;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color.withValues(alpha: 0.12),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          width: size,
          height: size,
          child: Icon(icon, color: color, size: iconSize),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────
// Empty State
// ─────────────────────────────────────────────────
class _EmptyWirdView extends StatelessWidget {
  const _EmptyWirdView({
    required this.isAr,
    required this.isDark,
    required this.userName,
    required this.fadeAnim,
    required this.onCreatePressed,
  });

  final bool isAr;
  final bool isDark;
  final String userName;
  final Animation<double> fadeAnim;
  final VoidCallback onCreatePressed;

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: fadeAnim,
      child: SafeArea(
        child: Column(
          children: [
            // Mini header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(
                children: [
                  Text(
                    isAr ? 'وِردي اليومي' : 'My Daily Wird',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Center(
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
                          Icons.auto_stories_rounded,
                          size: 60,
                          color: AppColors.teal,
                        ),
                      ),
                      const SizedBox(height: 28),
                      Text(
                        isAr
                            ? (userName.isNotEmpty
                                ? 'أهلاً $userName،\nلم تُنشئ وِرداً بعد'
                                : 'لم تُنشئ وِرداً بعد')
                            : (userName.isNotEmpty
                                ? 'Welcome $userName,\nNo wird created yet'
                                : 'No wird created yet'),
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black87,
                          height: 1.4,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        isAr
                            ? 'ابدأ رحلتك الروحانية بتحديد أهداف يومية للقرآن والأذكار والتسبيح'
                            : 'Set your daily goals for Quran, Adhkar, and Tasbeeh',
                        style: TextStyle(
                          fontSize: 14,
                          color: isDark ? Colors.white70 : Colors.grey[600],
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 36),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: onCreatePressed,
                          icon: const Icon(Icons.add_circle_outline),
                          label: Text(
                            isAr ? 'إنشاء وِرد يومي' : 'Create Daily Wird',
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.teal,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────
// Sign-in required view
// ─────────────────────────────────────────────────
class _SignInRequiredView extends StatelessWidget {
  const _SignInRequiredView({required this.isAr, required this.isDark});

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
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppColors.teal.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.lock_outline, size: 50, color: AppColors.teal),
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
            ElevatedButton.icon(
              onPressed: () => context.push('/login'),
              icon: const Icon(Icons.login_rounded),
              label: Text(
                isAr ? 'تسجيل الدخول' : 'Sign In',
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w600),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.teal,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 36, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
