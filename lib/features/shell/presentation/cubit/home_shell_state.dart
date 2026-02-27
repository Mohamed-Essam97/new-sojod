import 'package:equatable/equatable.dart';

class HomeShellState extends Equatable {
  final int currentIndex;

  const HomeShellState({this.currentIndex = 0});

  HomeShellState copyWith({int? currentIndex}) {
    return HomeShellState(
      currentIndex: currentIndex ?? this.currentIndex,
    );
  }

  @override
  List<Object?> get props => [currentIndex];
}
