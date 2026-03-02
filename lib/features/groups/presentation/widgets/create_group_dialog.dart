import 'package:flutter/material.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';

typedef CreateGroupCallback = Future<void> Function(
  String name,
  String? description,
  String? photoUrl,
);

class CreateGroupDialog extends StatefulWidget {
  const CreateGroupDialog({
    super.key,
    required this.onCreateGroup,
  });

  /// Callback to create the group. Return a Future so the dialog can show loading.
  final CreateGroupCallback onCreateGroup;

  @override
  State<CreateGroupDialog> createState() => _CreateGroupDialogState();
}

class _CreateGroupDialogState extends State<CreateGroupDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _photoUrlController = TextEditingController();

  static const int _maxNameLength = 50;
  static const int _maxDescriptionLength = 200;

  bool _isCreating = false;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _photoUrlController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate() || _isCreating) return;

    setState(() => _isCreating = true);

    try {
      await widget.onCreateGroup(
        _nameController.text.trim(),
        _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        _photoUrlController.text.trim().isEmpty
            ? null
            : _photoUrlController.text.trim(),
      );
      if (mounted) Navigator.of(context).pop();
    } catch (_) {
      if (mounted) {
        setState(() => _isCreating = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isAr = l10n.locale.languageCode == 'ar';
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
    );
    final fillColor = isDark ? Colors.grey.withValues(alpha: 0.15) : Colors.grey.withValues(alpha: 0.08);

    return PopScope(
      canPop: !_isCreating,
      child: AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.violet.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.groups_rounded,
                color: AppColors.violet,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                isAr ? 'إنشاء مجموعة' : 'Create Group',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.onSurfaceColor(context),
                ),
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  isAr
                      ? 'أنشئ مجموعة لمشاركة وِردك مع أصدقائك'
                      : 'Create a group to share your wird with friends',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.onSurfaceMutedColor(context),
                  ),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _nameController,
                  textInputAction: TextInputAction.next,
                  maxLength: _maxNameLength,
                  enabled: !_isCreating,
                  style: TextStyle(
                    color: AppColors.onSurfaceColor(context),
                  ),
                  decoration: InputDecoration(
                    labelText: isAr ? 'اسم المجموعة *' : 'Group Name *',
                    hintText: isAr ? 'مثال: وِرد العائلة' : 'e.g. Family Wird',
                    counterText: '',
                    prefixIcon: const Icon(
                      Icons.label_outline_rounded,
                      color: AppColors.violet,
                    ),
                    border: border,
                    enabledBorder: border.copyWith(
                      borderSide: BorderSide(
                        color: isDark ? Colors.white24 : Colors.grey.shade300,
                      ),
                    ),
                    focusedBorder: border.copyWith(
                      borderSide: const BorderSide(
                        color: AppColors.violet,
                        width: 2,
                      ),
                    ),
                    filled: true,
                    fillColor: fillColor,
                  ),
                  validator: (value) {
                    final t = value?.trim() ?? '';
                    if (t.isEmpty) {
                      return isAr
                          ? 'الرجاء إدخال اسم المجموعة'
                          : 'Please enter a group name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  textInputAction: TextInputAction.next,
                  maxLines: 3,
                  maxLength: _maxDescriptionLength,
                  enabled: !_isCreating,
                  style: TextStyle(
                    color: AppColors.onSurfaceColor(context),
                  ),
                  decoration: InputDecoration(
                    labelText: isAr ? 'الوصف (اختياري)' : 'Description (optional)',
                    counterText: '',
                    alignLabelWithHint: true,
                    prefixIcon: const Padding(
                      padding: EdgeInsets.only(bottom: 48),
                      child: Icon(
                        Icons.description_outlined,
                        color: AppColors.violet,
                      ),
                    ),
                    border: border,
                    enabledBorder: border.copyWith(
                      borderSide: BorderSide(
                        color: isDark ? Colors.white24 : Colors.grey.shade300,
                      ),
                    ),
                    focusedBorder: border.copyWith(
                      borderSide: const BorderSide(
                        color: AppColors.violet,
                        width: 2,
                      ),
                    ),
                    filled: true,
                    fillColor: fillColor,
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _photoUrlController,
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.url,
                  enabled: !_isCreating,
                  style: TextStyle(
                    color: AppColors.onSurfaceColor(context),
                  ),
                  decoration: InputDecoration(
                    labelText: isAr ? 'رابط الصورة (اختياري)' : 'Photo URL (optional)',
                    prefixIcon: const Icon(
                      Icons.image_outlined,
                      color: AppColors.violet,
                    ),
                    border: border,
                    enabledBorder: border.copyWith(
                      borderSide: BorderSide(
                        color: isDark ? Colors.white24 : Colors.grey.shade300,
                      ),
                    ),
                    focusedBorder: border.copyWith(
                      borderSide: const BorderSide(
                        color: AppColors.violet,
                        width: 2,
                      ),
                    ),
                    filled: true,
                    fillColor: fillColor,
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: _isCreating ? null : () => Navigator.of(context).pop(),
            child: Text(
              isAr ? 'إلغاء' : 'Cancel',
              style: TextStyle(
                color: AppColors.onSurfaceMutedColor(context),
              ),
            ),
          ),
          FilledButton(
            onPressed: _isCreating ? null : _submit,
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.violet,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: _isCreating
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : Text(isAr ? 'إنشاء' : 'Create'),
          ),
        ],
      ),
    );
  }
}
