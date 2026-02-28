import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';

class CreateWirdDialog extends StatefulWidget {
  const CreateWirdDialog({super.key, required this.onCreateWird});

  final Function(int quranPages, int tasbeehCount) onCreateWird;

  @override
  State<CreateWirdDialog> createState() => _CreateWirdDialogState();
}

class _CreateWirdDialogState extends State<CreateWirdDialog> {
  final _quranController = TextEditingController(text: '2');
  final _tasbeehController = TextEditingController(text: '100');

  @override
  void dispose() {
    _quranController.dispose();
    _tasbeehController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isAr = l10n.locale.languageCode == 'ar';
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.teal.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.add_task_rounded, color: AppColors.teal, size: 22),
          ),
          const SizedBox(width: 12),
          Text(
            isAr ? 'إنشاء وِرد يومي' : 'Create Daily Wird',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isAr ? 'حدد أهدافك اليومية' : 'Set your daily goals',
              style: TextStyle(
                fontSize: 14,
                color: isDark ? Colors.white70 : Colors.grey[600],
              ),
            ),
            const SizedBox(height: 20),
            _InputField(
              controller: _quranController,
              label: isAr ? 'عدد صفحات القرآن' : 'Quran Pages',
              icon: Icons.menu_book_rounded,
              iconColor: AppColors.teal,
              isDark: isDark,
            ),
            const SizedBox(height: 16),
            _InputField(
              controller: _tasbeehController,
              label: isAr ? 'عدد التسبيح' : 'Tasbeeh Count',
              icon: Icons.star_rounded,
              iconColor: AppColors.violet,
              isDark: isDark,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            isAr ? 'إلغاء' : 'Cancel',
            style: TextStyle(color: isDark ? Colors.white70 : Colors.grey[600]),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            final quranPages = int.tryParse(_quranController.text) ?? 0;
            final tasbeehCount = int.tryParse(_tasbeehController.text) ?? 0;
            widget.onCreateWird(quranPages, tasbeehCount);
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.teal,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: Text(isAr ? 'إنشاء' : 'Create'),
        ),
      ],
    );
  }
}

class _InputField extends StatelessWidget {
  const _InputField({
    required this.controller,
    required this.label,
    required this.icon,
    required this.iconColor,
    required this.isDark,
  });

  final TextEditingController controller;
  final String label;
  final IconData icon;
  final Color iconColor;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      style: TextStyle(color: isDark ? Colors.white : Colors.black87),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: isDark ? Colors.white70 : Colors.grey[600]),
        prefixIcon: Icon(icon, color: iconColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: isDark ? Colors.white24 : Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: isDark ? Colors.white24 : Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: iconColor, width: 2),
        ),
        filled: true,
        fillColor: isDark ? Colors.grey[850] : Colors.grey[50],
      ),
    );
  }
}
