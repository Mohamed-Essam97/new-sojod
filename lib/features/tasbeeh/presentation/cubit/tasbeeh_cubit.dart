import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/repositories/tasbeeh_repository.dart';

import 'tasbeeh_state.dart';

class TasbeehCubit extends Cubit<TasbeehState> {
  final TasbeehRepository _repository;

  TasbeehCubit(this._repository) : super(TasbeehState.initial()) {
    emit(state.copyWith(count: _repository.getLastCount()));
  }

  void increment() {
    final newCount = state.count + 1;
    _repository.setCount(newCount);
    emit(state.copyWith(count: newCount));
  }

  void reset() {
    _repository.setCount(0);
    emit(state.copyWith(count: 0));
  }
}
