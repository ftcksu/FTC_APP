import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:ftc_application/repositories/ftc_repository.dart';
import 'package:ftc_application/src/models/Task.dart';
import './bloc.dart';

class MemberTasksBloc extends Bloc<MemberTasksEvent, MemberTasksState> {
  final FtcRepository ftcRepository;
  MemberTasksBloc({@required this.ftcRepository})
      : assert(ftcRepository != null);
  @override
  MemberTasksState get initialState => InitialMemberTasksState();

  @override
  Stream<MemberTasksState> mapEventToState(
    MemberTasksEvent event,
  ) async* {
    if (event is GetMemberJobTasks) {
      yield* _mapGetMemberJobTasks(event.jobId);
    } else if (event is GetMemberSelfTasks) {
      yield* _mapGetMemberSelfTasks(event.jobId);
    }

    if (event is UpdateTaskApproval) {
      await ftcRepository.updateTaskEventLeader(
          event.eventId, event.taskId, event.approval);
      yield InitialMemberTasksState();
    }

    if (event is EditTask) {
      await ftcRepository.editTask(
          event.taskId, event.description, event.userSub);
      yield InitialMemberTasksState();
    }

    if (event is RefreshMemberTasks) {
      yield* _mapGetMemberSelfTasks(event.jobId);
      yield InitialMemberTasksState();
    }
  }

  Stream<MemberTasksState> _mapGetMemberJobTasks(int jobId) async* {
    yield MemberTasksLoading();
    final List<Task> memberTasks = await ftcRepository.getMemberJobTasks(jobId);
    yield MemberTasksLoaded(memberTasks: memberTasks);
  }

  Stream<MemberTasksState> _mapGetMemberSelfTasks(int jobId) async* {
    yield GetMemberSelfTasksLoading();
    final List<Task> memberTasks = await ftcRepository.getMemberJobTasks(jobId);
    yield GetMemberSelfTasksLoaded(memberTasks: memberTasks);
  }
}
