import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/localization/app_localizations.dart';
import '../cubit/hijri_cubit.dart';
import '../cubit/hijri_state.dart';

class HijriPage extends StatelessWidget {
  const HijriPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<HijriCubit>(),
      child: const _HijriView(),
    );
  }
}

class _HijriView extends StatelessWidget {
  const _HijriView();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.translate('hijri')),
      ),
      body: BlocBuilder<HijriCubit, HijriState>(
        builder: (context, state) {
          final hijri = state?.hijriDate;
          final gregorian = state?.gregorianDate;

          return Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      children: [
                        if (hijri != null) ...[
                          Text(
                            '${hijri.hDay} ${hijri.getLongMonthName()} ${hijri.hYear}',
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                  color: AppColors.teal,
                                  fontWeight: FontWeight.bold,
                                ),
                            textDirection: ui.TextDirection.rtl,
                          ),
                          Text(
                            'Hijri',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Colors.grey,
                                ),
                          ),
                        ],
                        if (gregorian != null) ...[
                          const SizedBox(height: 24),
                          Text(
                            DateFormat('EEEE, d MMMM yyyy').format(gregorian),
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          Text(
                            'Gregorian',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Colors.grey,
                                ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                Text('Adjustment: ${state?.adjustment ?? 0} days'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton.filled(
                      icon: const Icon(Icons.remove),
                      onPressed: () =>
                          context.read<HijriCubit>().setAdjustment((state?.adjustment ?? 0) - 1),
                    ),
                    const SizedBox(width: 24),
                    IconButton.filled(
                      icon: const Icon(Icons.add),
                      onPressed: () =>
                          context.read<HijriCubit>().setAdjustment((state?.adjustment ?? 0) + 1),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
