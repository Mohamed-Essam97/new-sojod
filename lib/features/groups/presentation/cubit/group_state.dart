import 'package:equatable/equatable.dart';

import '../../domain/entities/group_entity.dart';
import '../../domain/entities/group_member_entity.dart';

abstract class GroupState extends Equatable {
  const GroupState();

  @override
  List<Object?> get props => [];
}

class GroupInitial extends GroupState {
  const GroupInitial();
}

class GroupLoading extends GroupState {
  const GroupLoading();
}

class GroupsLoaded extends GroupState {
  const GroupsLoaded(this.groups);

  final List<GroupEntity> groups;

  @override
  List<Object?> get props => [groups];
}

class GroupDetailsLoaded extends GroupState {
  const GroupDetailsLoaded(this.group, this.members);

  final GroupEntity group;
  final List<GroupMemberEntity> members;

  @override
  List<Object?> get props => [group, members];
}

class GroupError extends GroupState {
  const GroupError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

class GroupSuccess extends GroupState {
  const GroupSuccess(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
