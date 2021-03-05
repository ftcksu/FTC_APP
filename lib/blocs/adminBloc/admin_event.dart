import 'package:equatable/equatable.dart';
import 'package:ftc_application/src/models/PushNotificationRequest.dart';

abstract class AdminEvent extends Equatable {
  const AdminEvent();
  @override
  List<Object> get props => [];
}

class GetSelfJobs extends AdminEvent {}

class UpdateTask extends AdminEvent {
  final int taskId;
  final Map<String, dynamic> payload;

  UpdateTask({this.taskId, this.payload})
      : assert(taskId != null, payload != null);
}

class AdminSubmitPoints extends AdminEvent {
  final int memberId;
  final Map<String, dynamic> payload;

  AdminSubmitPoints({this.memberId, this.payload}) : assert(payload != null);
}
