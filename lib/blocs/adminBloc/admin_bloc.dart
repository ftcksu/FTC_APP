import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:ftc_application/repositories/ftc_repository.dart';
import 'package:ftc_application/src/models/Job.dart';
import './bloc.dart';

class AdminBloc extends Bloc<AdminEvent, AdminState> {
  final FtcRepository ftcRepository;
  AdminBloc({@required this.ftcRepository}) : assert(ftcRepository != null);

  @override
  AdminState get initialState => InitialAdminState();

  @override
  Stream<AdminState> mapEventToState(
    AdminEvent event,
  ) async* {
    if (event is GetSelfJobs) {
      yield AdminGetJobsLoading();
      final List<Job> adminJobs = await ftcRepository.getSelfJobs();
      yield AdminGetJobsLoaded(jobs: adminJobs);
    }

    if (event is AdminSubmitPoints) {
      await ftcRepository.adminSubmitPoints(event.memberId, event.payload);
    }
    if (event is UpdateTask) {
      await ftcRepository.adminUpdateTask(event.taskId, event.payload);
    }
  }
}
