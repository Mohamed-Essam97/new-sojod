import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection.dart';
import '../cubit/adhkar_cubit.dart';
import '../cubit/adhkar_state.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/localization/app_localizations.dart';
import '../cubit/adhkar_cubit.dart';

class AdhkarPage extends StatelessWidget {
  const AdhkarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AdhkarCubit>(),
      child: const _AdhkarView(),
    );
  }
}

void _showCategorySheet(
  BuildContext context,
  String categoryId,
  AdhkarState state,
) {
  final cat = state.categories.firstWhere((c) => c.id == categoryId);
  final isAr = Localizations.localeOf(context).languageCode == 'ar';
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (ctx) => DraggableScrollableSheet(
      initialChildSize: 0.7,
      expand: false,
      builder: (_, controller) => Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              isAr ? cat.nameAr : cat.nameEn,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          Expanded(
            child: ListView.builder(
              controller: controller,
              itemCount: cat.dhikrs.length,
              itemBuilder: (_, i) {
                final d = cat.dhikrs[i];
                return ListTile(
                  title: Text(
                    d.arabic,
                    textDirection: TextDirection.rtl,
                  ),
                  subtitle: d.translation != null ? Text(d.translation!) : null,
                );
              },
            ),
          ),
        ],
      ),
    ),
  );
}

class _AdhkarView extends StatelessWidget {
  const _AdhkarView();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isAr = Localizations.localeOf(context).languageCode == 'ar';

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.translate('adhkar')),
      ),
      body: BlocBuilder<AdhkarCubit, AdhkarState>(
        builder: (context, state) {
          final categories = state.categories;
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: categories.length,
            itemBuilder: (context, i) {
              final cat = categories[i];
              final completed = state.getCompleted(cat.id);
              final total = state.getTotal(cat.id);
              final name = isAr ? cat.nameAr : cat.nameEn;

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: CircleAvatar(
                    backgroundColor: AppColors.teal.withOpacity(0.2),
                    child: Text('$completed/$total'),
                  ),
                  title: Text(name),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () => _showCategorySheet(context, cat.id, state),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
