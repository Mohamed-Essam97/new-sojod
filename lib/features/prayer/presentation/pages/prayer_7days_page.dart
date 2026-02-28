import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/services/prayer_service.dart';
import '../../../../core/theme/app_colors.dart';

/// Full list of upcoming prayers for the next 7 days.
class Prayer7DaysPage extends StatefulWidget {
  const Prayer7DaysPage({super.key});

  @override
  State<Prayer7DaysPage> createState() => _Prayer7DaysPageState();
}

class _Prayer7DaysPageState extends State<Prayer7DaysPage> {
  List<({String key, DateTime time, DateTime date})>? _prayers;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final service = sl<PrayerService>();
    final loc = await service.getLocation();
    if (loc.lat == null || loc.lng == null) {
      setState(() {
        _error = 'Enable location for prayer times';
      });
      return;
    }
    final prayers =
        service.getUpcomingPrayersNext7Days(loc.lat!, loc.lng!);
    setState(() {
      _prayers = prayers;
      _error = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.translate('upcomingPrayers')),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: _error != null
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.location_off, size: 64, color: Colors.grey),
                    const SizedBox(height: 16),
                    Text(
                      _error!,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 24),
                    FilledButton(
                      onPressed: () => context.push('/permissions'),
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.teal,
                      ),
                      child: Text(l10n.translate('openSettings')),
                    ),
                  ],
                ),
              ),
            )
          : _prayers == null
              ? const Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                  onRefresh: _load,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: _prayers!.length,
                    itemBuilder: (context, i) {
                      final p = _prayers![i];
                      final name = _getPrayerName(p.key, p.date, l10n);
                      final dateStr = _formatDate(p.date, l10n);
                      final timeStr = DateFormat.jm().format(p.time);
                      return Card(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor:
                                AppColors.teal.withValues(alpha: 0.15),
                            child: const Icon(
                              Icons.mosque_rounded,
                              color: AppColors.teal,
                              size: 22,
                            ),
                          ),
                          title: Text(
                            name,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          subtitle: Text(dateStr),
                          trailing: Text(
                            timeStr,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: AppColors.teal,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }

  String _getPrayerName(String key, DateTime date, AppLocalizations l10n) {
    if (key == 'dhuhr' && date.weekday == DateTime.friday) {
      return l10n.translate('jumuah');
    }
    return l10n.translate(key);
  }

  String _formatDate(DateTime date, AppLocalizations l10n) {
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);
    final dateOnly = DateTime(date.year, date.month, date.day);
    final diff = dateOnly.difference(todayDate).inDays;
    if (diff == 0) return l10n.translate('today');
    if (diff == 1) return l10n.translate('tomorrow');
    return DateFormat('EEEE, MMM d', l10n.locale.languageCode).format(date);
  }
}
