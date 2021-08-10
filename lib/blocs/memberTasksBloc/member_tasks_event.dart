import 'package:equatable/equatable.dart';

abstract class MemberTasksEvent extends Equatable {
  const MemberTasksEvent();
  @override
  List<Object> get props => [];
}

class GetMemberJobTasks extends MemberTasksEvent {
  final int jobId;
  GetMemberJobTasks({required this.jobId});
}

class GetMemberSelfTasks extends MemberTasksEvent {
  final int jobId;

  GetMemberSelfTasks({required this.jobId});
}

class EditTask extends MemberTasksEvent {
  final int taskId;
  final String description;
  final bool userSub;

  EditTask(
      {required this.taskId, required this.description, required this.userSub});
}

class UpdateTaskApproval extends MemberTasksEvent {
  final int eventId;
  final int taskId;
  final String approval;

  UpdateTaskApproval(
      {required this.eventId, required this.taskId, required this.approval});
}

class RefreshMemberTasks extends MemberTasksEvent {
  final int jobId;

  RefreshMemberTasks({required this.jobId});
}
