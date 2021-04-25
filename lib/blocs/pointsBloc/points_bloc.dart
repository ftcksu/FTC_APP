import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:ftc_application/repositories/ftc_repository.dart';
import 'package:ftc_application/src/models/route_argument.dart';
import './bloc.dart';

class PointsBloc extends Bloc<PointsEvent, PointsState> {
  final FtcRepository ftcRepository;
  RouteArgument pointsPageInfo;
  PointsBloc({@required this.ftcRepository})
      : assert(ftcRepository != null),
        super(null);

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
      pointsPageInfo = await ftcRepository.getPointsList();
      yield PointsPageLoaded(pointsPageInfo: pointsPageInfo);
    } catch (e) {
      yield PointsPageLoading();
      await ftcRepository.reLogIn();
      yield InitialPointsState();
    }
  }
}
