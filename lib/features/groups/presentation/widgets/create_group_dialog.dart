import 'package:flutter/material.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';

class CreateGroupDialog extends StatefulWidget {
  const CreateGroupDialog({super.key, required this.onCreateGroup});

  final Function(String name, String? description, String? photoUrl) onCreateGroup;

  @override
  State<CreateGroupDialog> createState() => _CreateGroupDialogState();
}

class _CreateGroupDialogState extends State<CreateGroupDialog> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _photoUrlController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _photoUrlController.dispose();
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
              color: AppColors.violet.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.groups_rounded, color: AppColors.violet, size: 22),
          ),
          const SizedBox(width: 12),
          Text(
            isAr ? 'إنشاء مجموعة' : 'Create Group',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isAr ? 'أنشئ مجموعة لمشاركة وِردك مع أصدقائك' : 'Create a group to share your wird',
                style: TextStyle(
                  fontSize: 14,
                  color: isDark ? Colors.white70 : Colors.grey[600],
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _nameController,
                style: TextStyle(color: isDark ? Colors.white : Colors.black87),
                decoration: InputDecoration(
                  labelText: isAr ? 'اسم المجموعة *' : 'Group Name *',
                  labelStyle: TextStyle(color: isDark ? Colors.white70 : Colors.grey[600]),
                  prefixIcon: const Icon(Icons.label_outline, color: AppColors.violet),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: isDark ? Colors.white24 : Colors.grey[300]!,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.violet, width: 2),
                  ),
                  filled: true,
                  fillColor: isDark ? Colors.grey[850] : Colors.grey[50],
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return isAr ? 'الرجاء إدخال اسم المجموعة' : 'Please enter group name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                style: TextStyle(color: isDark ? Colors.white : Colors.black87),
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: isAr ? 'الوصف (اختياري)' : 'Description (optional)',
                  labelStyle: TextStyle(color: isDark ? Colors.white70 : Colors.grey[600]),
                  prefixIcon: const Icon(Icons.description_outlined, color: AppColors.violet),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: isDark ? Colors.white24 : Colors.grey[300]!,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.violet, width: 2),
                  ),
                  filled: true,
                  fillColor: isDark ? Colors.grey[850] : Colors.grey[50],
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _photoUrlController,
                style: TextStyle(color: isDark ? Colors.white : Colors.black87),
                decoration: InputDecoration(
                  labelText: isAr ? 'رابط الصورة (اختياري)' : 'Photo URL (optional)',
                  labelStyle: TextStyle(color: isDark ? Colors.white70 : Colors.grey[600]),
                  prefixIcon: const Icon(Icons.image_outlined, color: AppColors.violet),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: isDark ? Colors.white24 : Colors.grey[300]!,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.violet, width: 2),
                  ),
                  filled: true,
                  fillColor: isDark ? Colors.grey[850] : Colors.grey[50],
                ),
              ),
            ],
          ),
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
            if (_formKey.currentState!.validate()) {
              widget.onCreateGroup(
                _nameController.text.trim(),
                _descriptionController.text.trim().isEmpty
                    ? null
                    : _descriptionController.text.trim(),
                _photoUrlController.text.trim().isEmpty
                    ? null
                    : _photoUrlController.text.trim(),
              );
              Navigator.pop(context);
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.violet,
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
