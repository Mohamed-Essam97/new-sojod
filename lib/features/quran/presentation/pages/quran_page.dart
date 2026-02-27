import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../cubit/quran_cubit.dart';
import '../cubit/quran_state.dart';
import '../widgets/juz_grid.dart';
import '../widgets/quran_header.dart';
import '../widgets/search_and_tabs.dart';
import '../widgets/surah_list.dart';

class QuranPage extends StatelessWidget {
  const QuranPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<QuranCubit>(),
      child: const _QuranView(),
    );
  }
}

class _QuranView extends StatefulWidget {
  const _QuranView();

  @override
  State<_QuranView> createState() => _QuranViewState();
}

class _QuranViewState extends State<_QuranView>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final _searchController = TextEditingController();
  String _searchQuery = '';
  int _activeTab = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this)
      ..addListener(() {
        if (_tabController.indexIsChanging) return;
        setState(() {
          _activeTab = _tabController.index;
          _searchQuery = '';
          _searchController.clear();
        });
      });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return BlocBuilder<QuranCubit, QuranState>(
      builder: (context, state) {
        final cubit = context.read<QuranCubit>();
        final surahs = cubit.getSurahs();
        final filtered = _searchQuery.isEmpty
            ? surahs
            : surahs.where((s) =>
                s.nameEn.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                s.nameAr.contains(_searchQuery) ||
                s.number.toString() == _searchQuery).toList();

        return Scaffold(
          backgroundColor: AppColors.surface(context),
          body: Column(
            children: [
              QuranHeader(
                lastPage: state.lastReadPage,
                l10n: l10n,
                onContinue: () =>
                    context.push('/quran/reader?page=${state.lastReadPage}'),
              ),
              SearchAndTabs(
                tabController: _tabController,
                activeTab: _activeTab,
                searchController: _searchController,
                searchQuery: _searchQuery,
                l10n: l10n,
                onSearch: (q) => setState(() => _searchQuery = q),
                onTabTap: (i) => _tabController.animateTo(i),
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    SurahList(
                      surahs: filtered,
                      l10n: l10n,
                      onTap: (number) {
                        final surah = cubit.getSurah(number);
                        final page = surah.verses.isNotEmpty
                            ? surah.verses.first.page
                            : 1;
                        context.push('/quran/reader?page=$page');
                      },
                    ),
                    JuzGrid(
                      l10n: l10n,
                      onTap: (juz) {
                        final ayahs = cubit.getJuz(juz);
                        if (ayahs.isNotEmpty) {
                          context
                              .push('/quran/reader?page=${ayahs.first.page}');
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
