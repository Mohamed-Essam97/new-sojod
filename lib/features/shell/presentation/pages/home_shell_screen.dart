import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/assets/app_svgs.dart';
import '../../../home/presentation/pages/home_page.dart';
import '../../../hijri/presentation/pages/hijri_page.dart';
import '../../../adhkar/presentation/pages/adhkar_page.dart';
import '../../../settings/presentation/pages/settings_page.dart';
import '../cubit/home_shell_cubit.dart';
import '../cubit/home_shell_state.dart';
import '../widgets/custom_bottom_nav_bar.dart';

class HomeShellScreen extends StatelessWidget {
  const HomeShellScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeShellCubit(),
      child: const _HomeShellView(),
    );
  }
}

class _HomeShellView extends StatelessWidget {
  const _HomeShellView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: BlocBuilder<HomeShellCubit, HomeShellState>(
        builder: (context, state) {
          final idx = state?.currentIndex ?? 0;
          return IndexedStack(
            index: idx,
            children: const [
              HomePage(),
              HijriPage(),
              AdhkarPage(),
              SettingsPage(),
            ],
          );
        },
      ),
      floatingActionButton: _QuranFab(onTap: () => context.push('/quran')),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BlocBuilder<HomeShellCubit, HomeShellState>(
        builder: (context, state) {
          return CustomBottomNavBar(
            currentIndex: state?.currentIndex ?? 0,
            onTap: (index) => context.read<HomeShellCubit>().changeTab(index),
          );
        },
      ),
    );
  }
}

class _QuranFab extends StatelessWidget {
  final VoidCallback onTap;

  const _QuranFab({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 56,
      height: 56,
      child: FloatingActionButton(
        onPressed: onTap,
        backgroundColor: AppColors.teal,
        foregroundColor: AppColors.onSurface,
        elevation: 6,
        child: SvgPicture.asset(
          AppSvgs.quran,
          width: 28,
          height: 28,
          colorFilter: const ColorFilter.mode(AppColors.onSurface, BlendMode.srcIn),
        ),
      ),
    );
  }
}
