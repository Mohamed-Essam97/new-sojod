import 'package:equatable/equatable.dart';

import '../../domain/entities/reciter.dart';

class ReciterState extends Equatable {
  const ReciterState({
    this.reciters = const [],
    this.selectedReciter,
    this.isLoading = false,
  });

  final List<Reciter> reciters;
  final Reciter? selectedReciter;
  final bool isLoading;

  ReciterState copyWith({
    List<Reciter>? reciters,
    Reciter? selectedReciter,
    bool? isLoading,
  }) {
    return ReciterState(
      reciters: reciters ?? this.reciters,
      selectedReciter: selectedReciter ?? this.selectedReciter,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [reciters, selectedReciter, isLoading];
}
