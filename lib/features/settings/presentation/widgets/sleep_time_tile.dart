import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../notifications/presentation/cubit/notification_cubit.dart';
import '../../../notifications/presentation/cubit/notification_state.dart';

class SleepTimeTile extends StatelessWidget {
  final bool isDark;

  const SleepTimeTile({super.key, required this.isDark});

  String _timeSubtitle(TimeOfDay t) {
    final h = t.hour > 12 ? t.hour - 12 : (t.hour == 0 ? 12 : t.hour);
    final m = t.minute.toString().padLeft(2, '0');
    final period = t.hour >= 12 ? 'PM' : 'AM';
    return '$h:$m $period';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return BlocBuilder<NotificationCubit, NotificationState>(
      builder: (context, notifState) {
        final adhkar = notifState.adhkarSettings;
        final enabled = adhkar.sleepEnabled;
        final time = adhkar.sleepTime;

        return ListTile(
          leading: Switch(
            value: enabled,
            onChanged: (v) {
              context.read<NotificationCubit>().setAdhkarSettings(
                    adhkar.copyWith(sleepEnabled: v),
                  );
            },
            activeColor: AppColors.teal,
          ),
          title: Text(
            l10n.translate('sleepAdhkarReminder'),
            style: TextStyle(
              color: isDark ? Colors.white : Colors.black87,
              fontSize: 14.5,
            ),
          ),
          subtitle: Text(
            '${l10n.translate('minutesBefore')} · ${_timeSubtitle(time)}',
            style: TextStyle(
              color: isDark ? Colors.white54 : Colors.black45,
              fontSize: 12.5,
            ),
          ),
          trailing: Icon(
            Icons.access_time_rounded,
            size: 20,
            color: isDark ? Colors.white38 : Colors.black38,
          ),
          onTap: () async {
            final picked = await showTimePicker(
              context: context,
              initialTime: time,
            );
            if (picked != null) {
              context.read<NotificationCubit>().setAdhkarSettings(
                    adhkar.copyWith(sleepTime: picked),
                  );
            }
          },
        );
      },
    );
  }
}
