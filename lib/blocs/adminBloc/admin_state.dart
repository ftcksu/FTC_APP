import 'package:equatable/equatable.dart';
import 'package:ftc_application/src/models/Job.dart';

abstract class AdminState extends Equatable {
  const AdminState();
  @override
  List<Object> get props => [];
}

class InitialAdminState extends AdminState {}

class EventTaskUpdating extends AdminState {}

class EventTaskUpdated extends AdminState {}

class AdminGetJobsLoading extends AdminState {}

class AdminGetJobsLoaded extends AdminState {
  final List<Job> jobs;

  AdminGetJobsLoaded({this.jobs}) : assert(jobs != null);
}
