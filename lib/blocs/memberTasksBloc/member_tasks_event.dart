import 'package:equatable/equatable.dart';

abstract class MemberTasksEvent extends Equatable {
  const MemberTasksEvent();
  @override
  List<Object> get props => [];
}

class GetMemberJobTasks extends MemberTasksEvent {
  final int jobId;
  GetMemberJobTasks({this.jobId}) : assert(jobId != null);
}

class GetMemberSelfTasks extends MemberTasksEvent {
  final int jobId;

  GetMemberSelfTasks({this.jobId}) : assert(jobId != null);
}

class EditTask extends MemberTasksEvent {
  final int taskId;
  final String description;
  final bool userSub;

  EditTask({this.taskId, this.description, this.userSub});
}

class UpdateTaskApproval extends MemberTasksEvent {
  final int eventId;
  final int taskId;
  final String approval;

  UpdateTaskApproval({this.eventId, this.taskId, this.approval});
}

class RefreshMemberTasks extends MemberTasksEvent {
  final int jobId;

  RefreshMemberTasks({this.jobId}) : assert(jobId != null);
}
