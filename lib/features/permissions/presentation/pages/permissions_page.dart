import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/assets/app_svgs.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../settings/domain/repositories/settings_repository.dart';

class PermissionsPage extends StatelessWidget {
  const PermissionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColors.darkBackground : AppColors.lightBackground;

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingScreenHorizontal),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(flex: 2),
              SvgPicture.asset(
                AppSvgs.notification,
                width: 64,
                height: 64,
                colorFilter: const ColorFilter.mode(AppColors.teal, BlendMode.srcIn),
              ),
              const SizedBox(height: 24),
              Text(
                l10n.translate('permissions'),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: AppColors.teal,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 32),
              _PermissionCard(
                assetPath: AppSvgs.location,
                title: l10n.translate('locationRequired'),
              ),
              const SizedBox(height: 16),
              _PermissionCard(
                assetPath: AppSvgs.notification,
                title: l10n.translate('notificationsRequired'),
              ),
              const Spacer(flex: 2),
              FilledButton(
                onPressed: () => _grantPermissions(context),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.teal,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(l10n.translate('grantPermissions')),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () async {
                  await sl<SettingsRepository>().setPermissionsGranted(true);
                  if (context.mounted) context.go('/home');
                },
                child: Text(
                  'Skip',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _grantPermissions(BuildContext context) async {
    await Permission.location.request();
    await Permission.notification.request();
    await sl<SettingsRepository>().setPermissionsGranted(true);
    if (context.mounted) {
      context.go('/home');
    }
  }
}

class _PermissionCard extends StatelessWidget {
  final String assetPath;
  final String title;

  const _PermissionCard({required this.assetPath, required this.title});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? AppColors.darkCard : Colors.white;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.teal.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: SvgPicture.asset(
              assetPath,
              width: 24,
              height: 24,
              colorFilter: const ColorFilter.mode(AppColors.teal, BlendMode.srcIn),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        ],
      ),
    );
  }
}
