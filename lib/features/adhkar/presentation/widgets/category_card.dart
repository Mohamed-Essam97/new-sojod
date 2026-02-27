import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/adhkar_category_entity.dart';
import 'category_meta.dart';

class CategoryCard extends StatelessWidget {
  const CategoryCard({
    super.key,
    required this.category,
    required this.completed,
    required this.total,
    required this.onTap,
  });

  final AdhkarCategoryEntity category;
  final int completed;
  final int total;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final meta = getCategoryMeta(category.id);
    final progress = total > 0 ? completed / total : 0.0;
    final isComplete = completed >= total && total > 0;

    return Material(
      color: isDark ? AppColors.darkCard : Colors.white,
      borderRadius: BorderRadius.circular(18),
      clipBehavior: Clip.antiAlias,
      elevation: 0,
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: isComplete
                  ? meta.color.withValues(alpha: 0.5)
                  : (isDark
                      ? Colors.white.withValues(alpha: 0.06)
                      : Colors.grey.withValues(alpha: 0.12)),
              width: 1.4,
            ),
            borderRadius: BorderRadius.circular(18),
          ),
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: meta.color.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(meta.icon, color: meta.color, size: 22),
                  ),
                  if (isComplete)
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: meta.color,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.check,
                          color: Colors.white, size: 12),
                    ),
                ],
              ),
              const Spacer(),
              Text(
                category.nameAr,
                textDirection: TextDirection.rtl,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 13.5,
                  fontFamily: 'Amiri',
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                category.nameEn,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 11,
                  color: isDark ? Colors.white54 : Colors.black45,
                ),
              ),
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 5,
                  backgroundColor: meta.color.withValues(alpha: 0.12),
                  valueColor: AlwaysStoppedAnimation<Color>(meta.color),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                '$completed / $total',
                style: TextStyle(
                  fontSize: 10.5,
                  color: isDark ? Colors.white38 : Colors.black38,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
