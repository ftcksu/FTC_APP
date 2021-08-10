import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:ftc_application/repositories/ftc_repository.dart';
import 'package:ftc_application/src/models/route_argument.dart';
import './bloc.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final FtcRepository ftcRepository;
  RouteArgument homePageInfo = RouteArgument(argumentsList: []);
  HomeBloc({required this.ftcRepository}) : super(InitialHomeState());

  HomeState get initialState => InitialHomeState();

  @override
  Stream<HomeState> mapEventToState(
    HomeEvent event,
  ) async* {
    if (event is GetHomePage) {
      yield* _mapGetHomePage();
    }

    if (event is RefreshHome) {
      yield* _mapGetHomePage();
    }
  }

  Stream<HomeState> _mapGetHomePage() async* {
    try {
      yield HomePageLoading();
      homePageInfo = await ftcRepository.getMemberHomePage();
      yield HomePageLoaded(homePageInfo: homePageInfo);
    } catch (e) {
      yield HomePageLoading();
      await ftcRepository.reLogIn();
      yield InitialHomeState();
    }
  }
}
