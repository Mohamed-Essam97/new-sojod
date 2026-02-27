import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({
    super.key,
    required this.greeting,
    required this.appName,
    required this.locationName,
    this.hijriDay,
    this.hijriMonth,
    this.hijriYear,
  });

  final String greeting;
  final String appName;
  final String locationName;
  final int? hijriDay;
  final String? hijriMonth;
  final int? hijriYear;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.teal, AppColors.tealDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Positioned(
              top: -20,
              right: -30,
              child: Container(
                width: 140,
                height: 140,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.overlayLight,
                ),
              ),
            ),
            Positioned(
              top: 30,
              right: 60,
              child: Container(
                width: 60,
                height: 60,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.cardLightTranslucent,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.mosque_rounded,
                                    color: Colors.white, size: 20),
                                const SizedBox(width: 6),
                                Text(
                                  appName,
                                  style: const TextStyle(
                                    color: AppColors.onSurfaceMuted,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              greeting,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                                height: 1.2,
                              ),
                            ),
                            if (locationName.isNotEmpty) ...[
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  const Icon(Icons.location_on_rounded,
                                      color: AppColors.onSurfaceMuted,
                                      size: 13),
                                  const SizedBox(width: 4),
                                  Text(
                                    locationName,
                                    style: const TextStyle(
                                      color: AppColors.onSurfaceMuted,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                      if (hijriDay != null && hijriMonth != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            color: AppColors.cardLightTranslucent,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                                color: AppColors.borderMuted, width: 1),
                          ),
                          child: Column(
                            children: [
                              Text(
                                '$hijriDay',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                  height: 1,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                hijriMonth!,
                                style: const TextStyle(
                                  color: AppColors.onSurfaceMuted,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              if (hijriYear != null)
                                Text(
                                  '${hijriYear!} AH',
                                  style: const TextStyle(
                                    color: AppColors.onSurfaceMuted,
                                    fontSize: 9,
                                  ),
                                ),
                            ],
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    DateFormat('EEEE, d MMMM yyyy').format(DateTime.now()),
                    style: const TextStyle(
                      color: AppColors.onSurfaceMuted,
                      fontSize: 12,
                    ),
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
