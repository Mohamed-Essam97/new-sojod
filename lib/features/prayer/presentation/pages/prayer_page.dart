import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/localization/app_localizations.dart';
import '../cubit/prayer_cubit.dart';
import '../cubit/prayer_state.dart';

class PrayerPage extends StatelessWidget {
  const PrayerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<PrayerCubit>(),
      child: const _PrayerView(),
    );
  }
}

class _PrayerView extends StatelessWidget {
  const _PrayerView();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.translate('prayer')),
      ),
      body: BlocBuilder<PrayerCubit, PrayerState>(
        builder: (context, state) {
          if (state.status == PrayerStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.status == PrayerStatus.error) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.location_off, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(
                    'Enable location to get prayer times',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            );
          }

          final times = state.prayerTimes;
          if (times == null) {
            return const Center(child: CircularProgressIndicator());
          }

          final format = DateFormat('HH:mm');

          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              if (state.nextPrayer != null && state.nextPrayerName != null)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Next: ${state.nextPrayerName!.toUpperCase()}',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                color: AppColors.teal,
                              ),
                        ),
                        if (state.countdown != null)
                          Text(
                            '${state.countdown!.inHours}:${(state.countdown!.inMinutes % 60).toString().padLeft(2, '0')}:${(state.countdown!.inSeconds % 60).toString().padLeft(2, '0')}',
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 24),
              _PrayerRow(
                name: l10n.translate('fajr'),
                time: format.format(times.fajr),
                enabled: state.enabledPrayers.contains('fajr'),
              ),
              _PrayerRow(
                name: l10n.translate('sunrise'),
                time: format.format(times.sunrise),
                enabled: false,
              ),
              _PrayerRow(
                name: l10n.translate('dhuhr'),
                time: format.format(times.dhuhr),
                enabled: state.enabledPrayers.contains('dhuhr'),
              ),
              _PrayerRow(
                name: l10n.translate('asr'),
                time: format.format(times.asr),
                enabled: state.enabledPrayers.contains('asr'),
              ),
              _PrayerRow(
                name: l10n.translate('maghrib'),
                time: format.format(times.maghrib),
                enabled: state.enabledPrayers.contains('maghrib'),
              ),
              _PrayerRow(
                name: l10n.translate('isha'),
                time: format.format(times.isha),
                enabled: state.enabledPrayers.contains('isha'),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _PrayerRow extends StatelessWidget {
  final String name;
  final String time;
  final bool enabled;

  const _PrayerRow({
    required this.name,
    required this.time,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        title: Text(name),
        trailing: Text(
          time,
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
    );
  }
}
