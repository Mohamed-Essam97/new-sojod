import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/localization/app_localizations.dart';
import '../cubit/tasbeeh_cubit.dart';
import '../cubit/tasbeeh_state.dart';

class TasbeehPage extends StatelessWidget {
  const TasbeehPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<TasbeehCubit>(),
      child: const _TasbeehView(),
    );
  }
}

class _TasbeehView extends StatelessWidget {
  const _TasbeehView();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.translate('tasbeeh')),
      ),
      body: Center(
        child: BlocBuilder<TasbeehCubit, TasbeehState>(
          builder: (context, state) {
            final s = state as TasbeehState? ?? TasbeehState.initial();
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () => context.read<TasbeehCubit>().increment(),
                  child: Container(
                    width: 180,
                    height: 180,
                    decoration: BoxDecoration(
                      color: AppColors.teal.withOpacity(0.2),
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.teal, width: 4),
                    ),
                    child: Center(
                      child: Text(
                        '${s.count}',
                        style: Theme.of(context).textTheme.displayLarge?.copyWith(
                              color: AppColors.teal,
                              fontWeight: FontWeight.bold,
                              fontFeatures: [
                                const FontFeature.tabularFigures(),
                              ],
                            ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Tap to count',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.grey,
                      ),
                ),
                const SizedBox(height: 32),
                FilledButton.icon(
                  onPressed: () => context.read<TasbeehCubit>().reset(),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Reset'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
