import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../notifications/domain/entities/prayer_notification_settings.dart';
import '../../../notifications/presentation/cubit/notification_cubit.dart';
import 'sheet_handle.dart';

class PrayerNotificationSheet extends StatelessWidget {
  final bool isDark;

  const PrayerNotificationSheet({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final cubit = context.read<NotificationCubit>();
    final state = cubit.state;

    final prayers = [
      ('fajr', l10n.translate('fajr'), state.prayerSettings.fajrEnabled),
      ('dhuhr', l10n.translate('dhuhr'), state.prayerSettings.dhuhrEnabled),
      ('asr', l10n.translate('asr'), state.prayerSettings.asrEnabled),
      ('maghrib', l10n.translate('maghrib'), state.prayerSettings.maghribEnabled),
      ('isha', l10n.translate('isha'), state.prayerSettings.ishaEnabled),
    ];

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SheetHandle(isDark: isDark),
            const SizedBox(height: 16),
            Text(
              l10n.translate('prayerNotifications'),
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            ...prayers.map((p) {
              return SwitchListTile(
                value: p.$3,
                onChanged: (v) {
                  PrayerNotificationSettings newSettings;
                  switch (p.$1) {
                    case 'fajr':
                      newSettings =
                          state.prayerSettings.copyWith(fajrEnabled: v);
                      break;
                    case 'dhuhr':
                      newSettings =
                          state.prayerSettings.copyWith(dhuhrEnabled: v);
                      break;
                    case 'asr':
                      newSettings =
                          state.prayerSettings.copyWith(asrEnabled: v);
                      break;
                    case 'maghrib':
                      newSettings =
                          state.prayerSettings.copyWith(maghribEnabled: v);
                      break;
                    case 'isha':
                      newSettings =
                          state.prayerSettings.copyWith(ishaEnabled: v);
                      break;
                    default:
                      return;
                  }
                  cubit.setPrayerSettings(newSettings);
                },
                title: Text(
                  p.$2,
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black87,
                    fontSize: 15,
                  ),
                ),
                activeColor: AppColors.teal,
              );
            }),
          ],
        ),
      ),
    );
  }
}
