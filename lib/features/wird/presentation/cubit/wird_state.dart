import 'package:equatable/equatable.dart';
import '../../domain/entities/wird_entity.dart';

abstract class WirdState extends Equatable {
  const WirdState();

  @override
  List<Object?> get props => [];
}

class WirdInitial extends WirdState {
  const WirdInitial();
}

class WirdLoading extends WirdState {
  const WirdLoading();
}

class WirdLoaded extends WirdState {
  const WirdLoaded(this.wird);

  final WirdEntity wird;

  @override
  List<Object?> get props => [wird];
}

class WirdEmpty extends WirdState {
  const WirdEmpty();
}

class WirdError extends WirdState {
  const WirdError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
