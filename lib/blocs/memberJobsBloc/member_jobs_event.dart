import 'package:equatable/equatable.dart';

abstract class MemberJobsEvent extends Equatable {
  const MemberJobsEvent();
  @override
  List<Object> get props => [];
}

class GetMemberJobs extends MemberJobsEvent {}

class GetCurrentMemberJobs extends MemberJobsEvent {}

class AddTaskToJob extends MemberJobsEvent {
  final int jobId;
  final Map<String, dynamic> payload;
  AddTaskToJob({this.jobId, this.payload})
      : assert(jobId != null, payload != null);
}

class RefreshMemberJobs extends MemberJobsEvent {}

class RefreshCurrentMemberJobs extends MemberJobsEvent {}

class GetEventJobs extends MemberJobsEvent {
  final int eventId;

  GetEventJobs({this.eventId}) : assert(eventId != null);
}
