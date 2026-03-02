import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../audio_player/presentation/widgets/persistent_audio_player.dart';
import '../../../home/presentation/pages/home_page.dart';
import '../../../quran/presentation/pages/quran_page.dart';
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
    return BlocBuilder<HomeShellCubit, HomeShellState>(
      builder: (context, state) {
        final idx = state.currentIndex;

        return Scaffold(
          extendBody: true,
          body: Stack(
            children: [
              IndexedStack(
                index: idx,
                children: const [
                  HomePage(),
                  QuranPage(),
                  AdhkarPage(),
                  SettingsPage(),
                ],
              ),
              // const PersistentAudioPlayer(),
            ],
          ),
          bottomNavigationBar: CustomBottomNavBar(
            currentIndex: idx,
            onTap: (i) => context.read<HomeShellCubit>().changeTab(i),
          ),
        );
      },
    );
  }
}
