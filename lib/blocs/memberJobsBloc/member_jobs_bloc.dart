import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:ftc_application/repositories/ftc_repository.dart';
import 'package:ftc_application/src/models/Job.dart';
import 'package:ftc_application/src/models/route_argument.dart';
import './bloc.dart';

class MemberJobsBloc extends Bloc<MemberJobsEvent, MemberJobsState> {
  final FtcRepository ftcRepository;
  MemberJobsBloc({@required this.ftcRepository})
      : assert(ftcRepository != null);
  @override
  MemberJobsState get initialState => InitialMemberJobsState();

  @override
  Stream<MemberJobsState> mapEventToState(
    MemberJobsEvent event,
  ) async* {
    if (event is GetMemberJobs) {
      yield* _mapGetMemberJobs();
    } else if (event is GetEventJobs) {
      yield* _mapGetEventJobs(event.eventId);
    } else if (event is GetCurrentMemberJobs) {
      yield* _mapCurrentMemberJobs();
    }

    if (event is RefreshMemberJobs) {
      yield* _mapGetMemberJobs();
    }

    if (event is RefreshCurrentMemberJobs) {
      yield* _mapCurrentMemberJobs();
    }

    if (event is AddTaskToJob) {
      ftcRepository.addTaskToJob(event.jobId, event.payload);
    }
  }

  Stream<MemberJobsState> _mapGetMemberJobs() async* {
    yield MemberJobsLoading();
    final RouteArgument jobsInfo =
        await ftcRepository.getMemberSubmissionJobs();
    yield MemberJobsLoaded(jobsInfo: jobsInfo);
  }

  Stream<MemberJobsState> _mapGetEventJobs(int eventId) async* {
    yield EventJobsLoading();
    List<Job> jobs = await ftcRepository.getEventJobs(eventId);
    yield EventJobsLoaded(jobs: jobs);
  }

  Stream<MemberJobsState> _mapCurrentMemberJobs() async* {
    yield CurrentMemberJobsLoading();
    final List<Job> jobs = await ftcRepository.getMemberJobs();
    yield CurrentMemberJobsLoaded(jobs: jobs);
  }
}
