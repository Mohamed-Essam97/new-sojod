import 'package:flutter_bloc/flutter_bloc.dart';

import 'home_shell_state.dart';

class HomeShellCubit extends Cubit<HomeShellState> {
  HomeShellCubit() : super(const HomeShellState(currentIndex: 0));

  void changeTab(int index) {
    if (index >= 0 && index < 4) {
      emit(state.copyWith(currentIndex: index));
    }
  }
}
