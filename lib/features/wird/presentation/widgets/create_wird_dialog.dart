import 'package:flutter/material.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';

class CreateWirdDialog extends StatefulWidget {
  const CreateWirdDialog({
    super.key,
    required this.onCreateWird,
    this.initialQuranPages,
    this.initialTasbeehCount,
  });

  final Function(int quranPages, int tasbeehCount) onCreateWird;
  final int? initialQuranPages;
  final int? initialTasbeehCount;

  @override
  State<CreateWirdDialog> createState() => _CreateWirdDialogState();
}

class _CreateWirdDialogState extends State<CreateWirdDialog> {
  late int _quranPages;
  late int _tasbeehCount;

  static const _quranPresets = [1, 2, 5, 10];
  static const _tasbeehPresets = [33, 100, 300, 500];

  @override
  void initState() {
    super.initState();
    _quranPages = widget.initialQuranPages ?? 2;
    _tasbeehCount = widget.initialTasbeehCount ?? 100;
  }

  void _apply() {
    widget.onCreateWird(_quranPages.clamp(1, 604), _tasbeehCount.clamp(1, 9999));
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isAr = l10n.locale.languageCode == 'ar';
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isEdit = widget.initialQuranPages != null;

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      backgroundColor: isDark ? const Color(0xFF1A2332) : Colors.white,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.teal, AppColors.tealDark],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.teal.withValues(alpha: 0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(
                      isEdit ? Icons.edit_rounded : Icons.add_task_rounded,
                      color: Colors.white,
                      size: 26,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isEdit
                              ? (isAr ? 'تعديل الأهداف' : 'Edit Targets')
                              : (isAr ? 'إنشاء وِرد يومي' : 'Create Daily Wird'),
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          isAr ? 'حدد أهدافك اليومية' : 'Set your daily goals',
                          style: TextStyle(
                            fontSize: 13,
                            color: isDark ? Colors.white54 : Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),

              // Quran Pages Card
              _GoalCard(
                isDark: isDark,
                icon: Icons.menu_book_rounded,
                iconColor: AppColors.teal,
                label: isAr ? 'صفحات القرآن' : 'Quran Pages',
                value: _quranPages,
                min: 1,
                max: 604,
                presets: _quranPresets,
                onChanged: (v) => setState(() => _quranPages = v),
                unit: isAr ? 'صفحة' : 'pages',
              ),
              const SizedBox(height: 16),

              // Tasbeeh Card
              _GoalCard(
                isDark: isDark,
                icon: Icons.star_rounded,
                iconColor: AppColors.violet,
                label: isAr ? 'عدد التسبيح' : 'Tasbeeh Count',
                value: _tasbeehCount,
                min: 1,
                max: 9999,
                presets: _tasbeehPresets,
                onChanged: (v) => setState(() => _tasbeehCount = v),
                unit: isAr ? 'مرة' : 'times',
              ),
              const SizedBox(height: 28),

              // Actions
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: isDark ? Colors.white70 : Colors.grey[700],
                        side: BorderSide(
                          color: isDark ? Colors.white24 : Colors.grey[300]!,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: Text(isAr ? 'إلغاء' : 'Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: _apply,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.teal,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            isEdit ? Icons.check_rounded : Icons.add_rounded,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            isEdit
                                ? (isAr ? 'حفظ' : 'Save')
                                : (isAr ? 'إنشاء وِرد' : 'Create Wird'),
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GoalCard extends StatelessWidget {
  const _GoalCard({
    required this.isDark,
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.presets,
    required this.onChanged,
    required this.unit,
  });

  final bool isDark;
  final IconData icon;
  final Color iconColor;
  final String label;
  final int value;
  final int min;
  final int max;
  final List<int> presets;
  final ValueChanged<int> onChanged;
  final String unit;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.05)
            : Colors.grey.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.white10 : Colors.grey.withValues(alpha: 0.15),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                label,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Stepper row
          Row(
            children: [
              _StepperButton(
                icon: Icons.remove_rounded,
                color: iconColor,
                onPressed: value > min ? () => onChanged(value - 1) : null,
              ),
              Expanded(
                child: Center(
                  child: Column(
                    children: [
                      Text(
                        '$value',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: iconColor,
                        ),
                      ),
                      Text(
                        unit,
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? Colors.white54 : Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              _StepperButton(
                icon: Icons.add_rounded,
                color: iconColor,
                onPressed: value < max ? () => onChanged(value + 1) : null,
              ),
            ],
          ),
          const SizedBox(height: 14),
          // Presets
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: presets
                .map(
                  (p) => _PresetChip(
                    value: p,
                    isSelected: value == p,
                    color: iconColor,
                    isDark: isDark,
                    onTap: () => onChanged(p),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _StepperButton extends StatelessWidget {
  const _StepperButton({
    required this.icon,
    required this.color,
    this.onPressed,
  });

  final IconData icon;
  final Color color;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: onPressed != null
          ? color.withValues(alpha: 0.12)
          : color.withValues(alpha: 0.05),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 48,
          height: 48,
          alignment: Alignment.center,
          child: Icon(
            icon,
            color: onPressed != null ? color : color.withValues(alpha: 0.4),
            size: 24,
          ),
        ),
      ),
    );
  }
}

class _PresetChip extends StatelessWidget {
  const _PresetChip({
    required this.value,
    required this.isSelected,
    required this.color,
    required this.isDark,
    required this.onTap,
  });

  final int value;
  final bool isSelected;
  final Color color;
  final bool isDark;

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isSelected
          ? color.withValues(alpha: 0.2)
          : (isDark ? Colors.white.withValues(alpha: 0.08) : Colors.grey.withValues(alpha: 0.1)),
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: isSelected
                ? Border.all(color: color, width: 1.5)
                : null,
          ),
          child: Text(
            '$value',
            style: TextStyle(
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              color: isSelected ? color : (isDark ? Colors.white70 : Colors.grey[700]),
            ),
          ),
        ),
      ),
    );
  }
}
