import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:ftc_application/repositories/ftc_repository.dart';
import 'package:ftc_application/src/models/Member.dart';
import './bloc.dart';

class PointsBloc extends Bloc<PointsEvent, PointsState> {
  final FtcRepository ftcRepository;
  PointsBloc({@required this.ftcRepository}) : assert(ftcRepository != null);

  @override
  PointsState get initialState => InitialPointsState();

  @override
  Stream<PointsState> mapEventToState(
    PointsEvent event,
  ) async* {
    if (event is GetPointsPage) {
      yield* _mapGetPointsPage();
    }

    if (event is RefreshPointsPage) {
      yield* _mapGetPointsPage();
    }
  }

  Stream<PointsState> _mapGetPointsPage() async* {
    try {
      yield PointsPageLoading();
      final List<Member> members = await ftcRepository.getPointsList();
      yield PointsPageLoaded(members: members);
    } catch (e) {
      yield PointsPageLoading();
      await ftcRepository.reLogIn();
      yield InitialPointsState();
    }
  }
}
