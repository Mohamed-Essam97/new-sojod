import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/localization/app_localizations.dart';
import '../cubit/quran_cubit.dart';
import '../cubit/quran_state.dart';

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

class _QuranView extends StatelessWidget {
  const _QuranView();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.translate('quran')),
          bottom: TabBar(
            tabs: [
              Tab(text: l10n.translate('readQuran')),
              const Tab(text: 'Surah'),
              const Tab(text: 'Juz'),
            ],
          ),
        ),
        body: BlocBuilder<QuranCubit, QuranState>(
          builder: (context, state) {
            final lastPage = state.lastReadPage;
            return TabBarView(
              children: [
                _ContinueReadingTab(
                  lastPage: lastPage,
                  onTap: () => context.go('/quran/reader?page=$lastPage'),
                ),
                _SurahListTab(cubit: context.read<QuranCubit>()),
                _JuzListTab(cubit: context.read<QuranCubit>()),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _ContinueReadingTab extends StatelessWidget {
  final int lastPage;
  final VoidCallback onTap;

  const _ContinueReadingTab({
    required this.lastPage,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Card(
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: AppColors.teal.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.menu_book, color: AppColors.teal, size: 32),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Continue Reading',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Text(
                          'Page $lastPage',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.grey,
                              ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios, size: 16),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _SurahListTab extends StatelessWidget {
  final QuranCubit cubit;

  const _SurahListTab({required this.cubit});

  @override
  Widget build(BuildContext context) {
    final surahs = cubit.getSurahs();

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: surahs.length,
      itemBuilder: (context, i) {
        final s = surahs[i];
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: AppColors.teal.withOpacity(0.2),
            child: Text('${s.number}'),
          ),
          title: Text(s.nameEn),
          subtitle: Text(s.nameAr, textDirection: TextDirection.rtl),
          trailing: Text('${s.ayahCount} verses'),
          onTap: () {
            final surah = cubit.getSurah(s.number);
            final page = surah.verses.isNotEmpty ? surah.verses.first.page : 1;
            context.go('/quran/reader?page=$page');
          },
        );
      },
    );
  }
}

class _JuzListTab extends StatelessWidget {
  final QuranCubit cubit;

  const _JuzListTab({required this.cubit});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: 30,
      itemBuilder: (context, i) {
        final juz = i + 1;
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: AppColors.teal.withOpacity(0.2),
            child: Text('$juz'),
          ),
          title: Text('Juz $juz'),
          onTap: () {
            final ayahs = cubit.getJuz(juz);
            if (ayahs.isNotEmpty) {
              context.go('/quran/reader?page=${ayahs.first.page}');
            }
          },
        );
      },
    );
  }
}
