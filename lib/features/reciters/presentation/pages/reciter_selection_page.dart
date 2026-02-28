import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/reciter.dart';
import '../cubit/reciter_cubit.dart';
import '../cubit/reciter_state.dart';
import '../widgets/reciter_list_item.dart';

class ReciterSelectionPage extends StatelessWidget {
  const ReciterSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    final l10n = AppLocalizations.of(context);

    return BlocProvider(
      create: (_) => sl<ReciterCubit>(),
      child: _ReciterSelectionView(isDark: isDark, isRtl: isRtl, l10n: l10n),
    );
  }
}

class _ReciterSelectionView extends StatefulWidget {
  const _ReciterSelectionView({
    required this.isDark,
    required this.isRtl,
    required this.l10n,
  });

  final bool isDark;
  final bool isRtl;
  final AppLocalizations l10n;

  @override
  State<_ReciterSelectionView> createState() => _ReciterSelectionViewState();
}

class _ReciterSelectionViewState extends State<_ReciterSelectionView> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          widget.isDark ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: AppBar(
        title: Text(
          widget.l10n.translate('chooseReciter'),
          style: TextStyle(
            color: widget.isDark ? Colors.white : Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: widget.isDark ? Colors.white : Colors.black87,
            size: 20,
          ),
          onPressed: () => context.pop(),
        ),
      ),
      body: BlocConsumer<ReciterCubit, ReciterState>(
        listenWhen: (a, b) => a.selectedReciter?.id != b.selectedReciter?.id,
        listener: (context, state) {
          if (state.selectedReciter != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(widget.l10n.translate('reciterChangedSuccess')),
                behavior: SnackBarBehavior.floating,
                backgroundColor: AppColors.teal,
              ),
            );
            context.pop();
          }
        },
        builder: (context, state) {
          final filtered = _query.isEmpty
              ? state.reciters
              : state.reciters
                  .where(
                    (r) =>
                        r.name.toLowerCase().contains(_query.toLowerCase()) ||
                        r.nameAr.contains(_query),
                  )
                  .toList();

          final popular = filtered.where((r) => r.isPopular).toList();
          final others = filtered.where((r) => !r.isPopular).toList();

          return CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                sliver: SliverToBoxAdapter(
                  child: TextField(
                    onChanged: (v) => setState(() => _query = v),
                    style: TextStyle(
                      color: widget.isDark ? Colors.white : Colors.black87,
                      fontSize: 15,
                    ),
                    decoration: InputDecoration(
                      hintText: widget.l10n.translate('searchReciters'),
                      hintStyle: TextStyle(
                        color: widget.isDark
                            ? Colors.white38
                            : Colors.black38,
                      ),
                      prefixIcon: const Icon(
                        Icons.search_rounded,
                        color: AppColors.teal,
                        size: 22,
                      ),
                      suffixIcon: _query.isNotEmpty
                          ? IconButton(
                              icon: Icon(
                                Icons.close_rounded,
                                size: 20,
                                color: widget.isDark
                                    ? Colors.white38
                                    : Colors.black38,
                              ),
                              onPressed: () =>
                                  setState(() => _query = ''),
                            )
                          : null,
                      filled: true,
                      fillColor: widget.isDark
                          ? Colors.white.withValues(alpha: 0.07)
                          : Colors.grey.withValues(alpha: 0.08),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                    ),
                  ),
                ),
              ),
              if (filtered.isEmpty)
                SliverFillRemaining(
                  child: Center(
                    child: Text(
                      widget.l10n.translate('noRecitersFound'),
                      style: TextStyle(
                        color: widget.isDark
                            ? Colors.white38
                            : Colors.black38,
                        fontSize: 15,
                      ),
                    ),
                  ),
                )
              else ...[
                if (popular.isNotEmpty) ...[
                  _SectionHeader(
                    title: widget.l10n.translate('popularReciters'),
                    isDark: widget.isDark,
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (_, i) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: ReciterListItem(
                            reciter: popular[i],
                            isSelected: state.selectedReciter?.id ==
                                popular[i].id,
                            isDark: widget.isDark,
                            isRtl: widget.isRtl,
                            onTap: () => _selectReciter(context, popular[i]),
                          ),
                        ),
                        childCount: popular.length,
                      ),
                    ),
                  ),
                ],
                if (others.isNotEmpty) ...[
                  _SectionHeader(
                    title: widget.l10n.translate('allReciters'),
                    isDark: widget.isDark,
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (_, i) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: ReciterListItem(
                            reciter: others[i],
                            isSelected: state.selectedReciter?.id ==
                                others[i].id,
                            isDark: widget.isDark,
                            isRtl: widget.isRtl,
                            onTap: () => _selectReciter(context, others[i]),
                          ),
                        ),
                        childCount: others.length,
                      ),
                    ),
                  ),
                ],
              ],
            ],
          );
        },
      ),
    );
  }

  void _selectReciter(BuildContext context, Reciter reciter) {
    context.read<ReciterCubit>().selectReciter(reciter);
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.isDark,
  });

  final String title;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      sliver: SliverToBoxAdapter(
        child: Text(
          title,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white54 : Colors.black54,
          ),
        ),
      ),
    );
  }
}
