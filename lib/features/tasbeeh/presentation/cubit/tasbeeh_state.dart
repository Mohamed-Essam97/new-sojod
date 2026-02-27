import 'package:equatable/equatable.dart';

class TasbeehState extends Equatable {
  final int count;

  const TasbeehState({this.count = 0});

  factory TasbeehState.initial() => const TasbeehState();

  TasbeehState copyWith({int? count}) {
    return TasbeehState(count: count ?? this.count);
  }

  @override
  List<Object?> get props => [count];
}
