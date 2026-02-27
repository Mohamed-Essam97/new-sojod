import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../notifications/domain/entities/adhkar_notification_settings.dart';
import '../../../notifications/presentation/cubit/notification_cubit.dart';
import '../../../notifications/presentation/cubit/notification_state.dart';

enum AdhkarNotificationType { morning, evening }

class AdhkarNotificationTile extends StatelessWidget {
  final AdhkarNotificationType type;
  final bool isDark;

  const AdhkarNotificationTile({
    super.key,
    required this.type,
    required this.isDark,
  });

  String _title(AppLocalizations l10n) {
    switch (type) {
      case AdhkarNotificationType.morning:
        return l10n.translate('morningAdhkarReminder');
      case AdhkarNotificationType.evening:
        return l10n.translate('eveningAdhkarReminder');
    }
  }

  String _timeSubtitle(TimeOfDay t) {
    final h = t.hour > 12 ? t.hour - 12 : (t.hour == 0 ? 12 : t.hour);
    final m = t.minute.toString().padLeft(2, '0');
    final period = t.hour >= 12 ? 'PM' : 'AM';
    return '$h:$m $period';
  }

  bool _getEnabled(AdhkarNotificationSettings s) {
    switch (type) {
      case AdhkarNotificationType.morning:
        return s.morningEnabled;
      case AdhkarNotificationType.evening:
        return s.eveningEnabled;
    }
  }

  TimeOfDay _getTime(AdhkarNotificationSettings s) {
    switch (type) {
      case AdhkarNotificationType.morning:
        return s.morningTime;
      case AdhkarNotificationType.evening:
        return s.eveningTime;
    }
  }

  AdhkarNotificationSettings _copyWithEnabled(
      AdhkarNotificationSettings s, bool v) {
    switch (type) {
      case AdhkarNotificationType.morning:
        return s.copyWith(morningEnabled: v);
      case AdhkarNotificationType.evening:
        return s.copyWith(eveningEnabled: v);
    }
  }

  AdhkarNotificationSettings _copyWithTime(
      AdhkarNotificationSettings s, TimeOfDay t) {
    switch (type) {
      case AdhkarNotificationType.morning:
        return s.copyWith(morningTime: t);
      case AdhkarNotificationType.evening:
        return s.copyWith(eveningTime: t);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return BlocBuilder<NotificationCubit, NotificationState>(
      builder: (context, notifState) {
        final adhkar = notifState.adhkarSettings;
        final enabled = _getEnabled(adhkar);
        final time = _getTime(adhkar);

        return ListTile(
          leading: Switch(
            value: enabled,
            onChanged: (v) {
              context.read<NotificationCubit>().setAdhkarSettings(
                    _copyWithEnabled(adhkar, v),
                  );
            },
            activeColor: AppColors.teal,
          ),
          title: Text(
            _title(l10n),
            style: TextStyle(
              color: isDark ? Colors.white : Colors.black87,
              fontSize: 14.5,
            ),
          ),
          subtitle: Text(
            _timeSubtitle(time),
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
                    _copyWithTime(adhkar, picked),
                  );
            }
          },
        );
      },
    );
  }
}
