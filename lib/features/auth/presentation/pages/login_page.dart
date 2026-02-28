import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is AuthLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDark
                    ? [AppColors.tealDark, const Color(0xFF004D40)]
                    : [AppColors.teal, AppColors.tealDark],
              ),
            ),
            child: SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Icon(
                          Icons.book_outlined,
                          size: 60,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 32),
                      Text(
                        'وِرد',
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: l10n.locale.languageCode == 'ar' ? 'QuranFont' : null,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.translate('appName'),
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 60),
                      Text(
                        l10n.locale.languageCode == 'ar'
                            ? 'ابدأ رحلتك الروحية'
                            : 'Start Your Spiritual Journey',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        l10n.locale.languageCode == 'ar'
                            ? 'سجل الدخول لمتابعة وِردك اليومي ومشاركته مع أصدقائك'
                            : 'Sign in to track and share your daily wird',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 48),
                      _SignInButton(
                        icon: Icons.g_mobiledata_rounded,
                        label: l10n.locale.languageCode == 'ar'
                            ? 'تسجيل الدخول بحساب Google'
                            : 'Continue with Google',
                        backgroundColor: Colors.white,
                        textColor: Colors.black87,
                        onPressed: () => context.read<AuthCubit>().signInWithGoogleMethod(),
                      ),
                      const SizedBox(height: 16),
                      _SignInButton(
                        icon: Icons.facebook_rounded,
                        label: l10n.locale.languageCode == 'ar'
                            ? 'تسجيل الدخول بحساب Facebook'
                            : 'Continue with Facebook',
                        backgroundColor: const Color(0xFF1877F2),
                        textColor: Colors.white,
                        onPressed: () => context.read<AuthCubit>().signInWithFacebookMethod(),
                      ),
                      const SizedBox(height: 32),
                      Text(
                        l10n.locale.languageCode == 'ar'
                            ? 'بالتسجيل، أنت توافق على شروط الاستخدام وسياسة الخصوصية'
                            : 'By signing in, you agree to our Terms and Privacy Policy',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white60,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      TextButton(
                        onPressed: () => context.push('/home'),
                        child: Text(
                          l10n.locale.languageCode == 'ar'
                              ? 'تخطي الآن'
                              : 'Skip for now',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _SignInButton extends StatelessWidget {
  const _SignInButton({
    required this.icon,
    required this.label,
    required this.backgroundColor,
    required this.textColor,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final Color backgroundColor;
  final Color textColor;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 28),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
