import 'package:flutter/material.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import 'reader_nav_btn.dart';

class ReaderBottomBar extends StatelessWidget {
  const ReaderBottomBar({
    super.key,
    required this.page,
    required this.l10n,
    required this.bgColor,
    required this.textColor,
    required this.onPrev,
    required this.onNext,
  });

  final int page;
  final AppLocalizations l10n;
  final Color bgColor;
  final Color textColor;
  final VoidCallback onPrev;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.07),
            blurRadius: 12,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              child: LinearProgressIndicator(
                value: page / 604,
                minHeight: 2,
                backgroundColor: textColor.withValues(alpha: 0.08),
                valueColor:
                    const AlwaysStoppedAnimation<Color>(AppColors.teal),
              ),
            ),
            SizedBox(
              height: 52,
              child: Row(
                children: [
                  ReaderNavBtn(
                    icon: Icons.chevron_left_rounded,
                    label: l10n.translate('prev'),
                    textColor: textColor,
                    onTap: onPrev,
                  ),
                  Expanded(
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.teal.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          l10n.translate('pageOf', [page.toString()]),
                          style: const TextStyle(
                            color: AppColors.teal,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ),
                  ),
                  ReaderNavBtn(
                    icon: Icons.chevron_right_rounded,
                    label: l10n.translate('next'),
                    textColor: textColor,
                    onTap: onNext,
                    isRight: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
