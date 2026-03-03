import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:go_router/go_router.dart';

import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../auth/presentation/cubit/auth_state.dart';
import '../widgets/splash_screen.dart';

/// Shows branding splash (1.2s animation), then navigates:
/// - If logged in -> /home
/// - Else -> /login
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  static const _splashDuration = Duration(milliseconds: 1200);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _navigateAfterSplash());
  }

  Future<void> _navigateAfterSplash() async {
    await Future.delayed(_splashDuration);
    if (!mounted) return;

    FlutterNativeSplash.remove();

    final authState = context.read<AuthCubit>().state;
    if (authState is AuthAuthenticated) {
      context.go('/home');
    } else {
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const SplashScreen();
  }
}
