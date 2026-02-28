import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/reciter.dart';
import '../../domain/usecases/get_all_reciters.dart';
import '../../domain/usecases/get_selected_reciter.dart';
import '../../domain/usecases/set_selected_reciter.dart';
import 'reciter_state.dart';

class ReciterCubit extends Cubit<ReciterState> {
  ReciterCubit(
    this._getAllReciters,
    this._getSelectedReciter,
    this._setSelectedReciter,
  ) : super(const ReciterState()) {
    loadReciters();
  }

  final GetAllReciters _getAllReciters;
  final GetSelectedReciter _getSelectedReciter;
  final SetSelectedReciter _setSelectedReciter;

  void loadReciters() {
    emit(state.copyWith(isLoading: true));
    final reciters = _getAllReciters();
    final selected = _getSelectedReciter();
    emit(state.copyWith(
      reciters: reciters,
      selectedReciter: selected,
      isLoading: false,
    ));
  }

  Future<void> selectReciter(Reciter reciter) async {
    await _setSelectedReciter(reciter);
    emit(state.copyWith(selectedReciter: reciter));
  }
}
