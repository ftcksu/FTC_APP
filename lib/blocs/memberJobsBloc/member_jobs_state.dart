import 'package:equatable/equatable.dart';
import 'package:ftc_application/src/models/Job.dart';
import 'package:ftc_application/src/models/route_argument.dart';

abstract class MemberJobsState extends Equatable {
  const MemberJobsState();
  @override
  List<Object> get props => [];
}

class InitialMemberJobsState extends MemberJobsState {}

class MemberJobsLoading extends MemberJobsState {}

class MemberJobsLoaded extends MemberJobsState {
  final RouteArgument jobsInfo;

  MemberJobsLoaded({this.jobsInfo}) : assert(jobsInfo != null);
}

class CurrentMemberJobsLoading extends MemberJobsState {}

class CurrentMemberJobsLoaded extends MemberJobsState {
  final List<Job> jobs;

  CurrentMemberJobsLoaded({this.jobs}) : assert(jobs != null);
}

class EventJobsLoading extends MemberJobsState {}

class EventJobsLoaded extends MemberJobsState {
  final List<Job> jobs;

  EventJobsLoaded({this.jobs}) : assert(jobs != null);
}
