import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/localization/app_localizations.dart';
import 'category_meta.dart';

class CounterWidget extends StatelessWidget {
  const CounterWidget({
    super.key,
    required this.current,
    required this.target,
    required this.progress,
    required this.isComplete,
    required this.meta,
    required this.l10n,
    required this.onTap,
    required this.onReset,
  });

  final int current;
  final int target;
  final double progress;
  final bool isComplete;
  final CategoryMeta meta;
  final AppLocalizations l10n;
  final VoidCallback onTap;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 150,
                height: 150,
                child: CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 8,
                  backgroundColor: meta.color.withValues(alpha: 0.12),
                  valueColor: AlwaysStoppedAnimation<Color>(meta.color),
                  strokeCap: StrokeCap.round,
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isComplete
                      ? meta.color
                      : meta.color.withValues(alpha: 0.08),
                  boxShadow: isComplete
                      ? [
                          BoxShadow(
                            color: meta.color.withValues(alpha: 0.35),
                            blurRadius: 20,
                            spreadRadius: 2,
                          ),
                        ]
                      : [],
                ),
                child: Center(
                  child: isComplete
                      ? const Icon(Icons.check_rounded,
                          color: Colors.white, size: 40)
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 200),
                              child: Text(
                                '$current',
                                key: ValueKey(current),
                                style: TextStyle(
                                  fontSize: 36,
                                  fontWeight: FontWeight.bold,
                                  color: meta.color,
                                ),
                              ),
                            ),
                            Text(
                              '/ $target',
                              style: TextStyle(
                                fontSize: 13,
                                color: meta.color.withValues(alpha: 0.6),
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Text(
          isComplete ? 'Completed! Tap to proceed' : 'Tap to count',
          style: TextStyle(
            fontSize: 12.5,
            color: isDark ? Colors.white38 : Colors.black38,
          ),
        ),
        const SizedBox(height: 12),
        if (current > 0)
          TextButton.icon(
            style: TextButton.styleFrom(
              foregroundColor: Colors.redAccent.withValues(alpha: 0.8),
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            ),
            icon: const Icon(Icons.refresh_rounded, size: 16),
            label: Text(l10n.translate('reset'), style: const TextStyle(fontSize: 12)),
            onPressed: onReset,
          ),
      ],
    );
  }
}
