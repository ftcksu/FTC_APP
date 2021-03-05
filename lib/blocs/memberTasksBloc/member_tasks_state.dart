import 'package:equatable/equatable.dart';
import 'package:ftc_application/src/models/Task.dart';

abstract class MemberTasksState extends Equatable {
  const MemberTasksState();
  @override
  List<Object> get props => [];
}

class InitialMemberTasksState extends MemberTasksState {}

class GetMemberSelfTasksLoading extends MemberTasksState {}

class GetMemberSelfTasksLoaded extends MemberTasksState {
  final List<Task> memberTasks;
  GetMemberSelfTasksLoaded({this.memberTasks}) : assert(memberTasks != null);
}

class MemberTasksLoading extends MemberTasksState {}

class MemberTasksLoaded extends MemberTasksState {
  final List<Task> memberTasks;
  MemberTasksLoaded({this.memberTasks}) : assert(memberTasks != null);
}
