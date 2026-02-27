import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class CategoryMeta {
  final IconData icon;
  final Color color;
  const CategoryMeta(this.icon, this.color);
}

const categoryMetaMap = <String, CategoryMeta>{
  'morning': CategoryMeta(Icons.wb_sunny_rounded, AppColors.amber),
  'evening': CategoryMeta(Icons.nightlight_round, AppColors.indigo),
  'wake_up': CategoryMeta(Icons.alarm_rounded, AppColors.red),
  'sleep': CategoryMeta(Icons.bedtime_rounded, AppColors.sky),
  'after_prayer': CategoryMeta(Icons.mosque_rounded, AppColors.teal),
  'going_out': CategoryMeta(Icons.directions_walk_rounded, AppColors.tealAccent),
  'entering_home': CategoryMeta(Icons.home_rounded, AppColors.emerald),
  'forgiveness': CategoryMeta(Icons.favorite_rounded, AppColors.rose),
  'tasbih': CategoryMeta(Icons.auto_awesome_rounded, AppColors.violet),
};

CategoryMeta getCategoryMeta(String id) =>
    categoryMetaMap[id] ?? CategoryMeta(Icons.circle, AppColors.grey);
