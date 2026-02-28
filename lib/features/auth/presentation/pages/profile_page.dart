import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0A1929) : Colors.grey[50],
      appBar: AppBar(
        title: Text(
          l10n.locale.languageCode == 'ar' ? 'الملف الشخصي' : 'Profile',
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          if (state is AuthLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is AuthAuthenticated) {
            final user = state.user;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Center(
                    child: Stack(
                      children: [
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.teal,
                              width: 3,
                            ),
                          ),
                          child: ClipOval(
                            child: user.photoUrl != null && user.photoUrl!.isNotEmpty
                                ? Image.network(
                                    user.photoUrl!,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) =>
                                        _DefaultAvatar(isDark: isDark),
                                  )
                                : _DefaultAvatar(isDark: isDark),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () => _showEditDialog(context, user.displayName, user.photoUrl),
                            child: Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: AppColors.teal,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isDark ? const Color(0xFF0A1929) : Colors.white,
                                  width: 3,
                                ),
                              ),
                              child: const Icon(
                                Icons.edit,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    user.displayName,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    user.email,
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark ? Colors.white70 : Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 32),
                  _ProfileInfoCard(
                    title: l10n.locale.languageCode == 'ar' ? 'معلومات الحساب' : 'Account Info',
                    items: [
                      _ProfileInfoItem(
                        icon: Icons.person_outline,
                        label: l10n.locale.languageCode == 'ar' ? 'الاسم' : 'Name',
                        value: user.displayName,
                      ),
                      _ProfileInfoItem(
                        icon: Icons.email_outlined,
                        label: l10n.locale.languageCode == 'ar' ? 'البريد الإلكتروني' : 'Email',
                        value: user.email,
                      ),
                      if (user.createdAt != null)
                        _ProfileInfoItem(
                          icon: Icons.calendar_today_outlined,
                          label: l10n.locale.languageCode == 'ar' ? 'انضم في' : 'Member since',
                          value: _formatDate(user.createdAt!),
                        ),
                    ],
                    isDark: isDark,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: () => _showSignOutDialog(context, l10n),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.logout),
                          const SizedBox(width: 8),
                          Text(
                            l10n.locale.languageCode == 'ar' ? 'تسجيل الخروج' : 'Sign Out',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return Center(
            child: Text(
              l10n.locale.languageCode == 'ar' ? 'لا يوجد مستخدم' : 'No user',
            ),
          );
        },
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _showEditDialog(BuildContext context, String currentName, String? currentPhotoUrl) {
    final nameController = TextEditingController(text: currentName);
    final photoUrlController = TextEditingController(text: currentPhotoUrl);
    final l10n = AppLocalizations.of(context);

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.locale.languageCode == 'ar' ? 'تعديل الملف الشخصي' : 'Edit Profile'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: l10n.locale.languageCode == 'ar' ? 'الاسم' : 'Name',
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: photoUrlController,
              decoration: InputDecoration(
                labelText: l10n.locale.languageCode == 'ar' ? 'رابط الصورة' : 'Photo URL',
                border: const OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(l10n.locale.languageCode == 'ar' ? 'إلغاء' : 'Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<AuthCubit>().updateUserProfile(
                    displayName: nameController.text.trim(),
                    photoUrl: photoUrlController.text.trim().isEmpty
                        ? null
                        : photoUrlController.text.trim(),
                  );
              Navigator.pop(dialogContext);
            },
            child: Text(l10n.locale.languageCode == 'ar' ? 'حفظ' : 'Save'),
          ),
        ],
      ),
    );
  }

  void _showSignOutDialog(BuildContext context, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.locale.languageCode == 'ar' ? 'تسجيل الخروج' : 'Sign Out'),
        content: Text(
          l10n.locale.languageCode == 'ar'
              ? 'هل أنت متأكد أنك تريد تسجيل الخروج؟'
              : 'Are you sure you want to sign out?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(l10n.locale.languageCode == 'ar' ? 'إلغاء' : 'Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<AuthCubit>().signOutMethod();
              Navigator.pop(dialogContext);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text(l10n.locale.languageCode == 'ar' ? 'تسجيل الخروج' : 'Sign Out'),
          ),
        ],
      ),
    );
  }
}

class _DefaultAvatar extends StatelessWidget {
  const _DefaultAvatar({required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: isDark ? Colors.grey[800] : Colors.grey[300],
      child: Icon(
        Icons.person,
        size: 60,
        color: isDark ? Colors.white54 : Colors.grey[600],
      ),
    );
  }
}

class _ProfileInfoCard extends StatelessWidget {
  const _ProfileInfoCard({
    required this.title,
    required this.items,
    required this.isDark,
  });

  final String title;
  final List<_ProfileInfoItem> items;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A2332) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          ...items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: item,
              )),
        ],
      ),
    );
  }
}

class _ProfileInfoItem extends StatelessWidget {
  const _ProfileInfoItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.teal.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: AppColors.teal,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? Colors.white60 : Colors.grey[600],
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
