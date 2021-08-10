import 'package:equatable/equatable.dart';

abstract class AdminEvent extends Equatable {
  const AdminEvent();
  @override
  List<Object> get props => [];
}

class GetSelfJobs extends AdminEvent {}

class UpdateTask extends AdminEvent {
  final int taskId;
  final Map<String, dynamic> payload;

  const UpdateTask({required this.taskId, required this.payload});
}

class AdminSubmitPoints extends AdminEvent {
  final int memberId;
  final Map<String, dynamic> payload;

  const AdminSubmitPoints({required this.memberId, required this.payload});
}
