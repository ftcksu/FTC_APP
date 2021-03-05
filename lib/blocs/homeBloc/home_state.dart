import 'package:equatable/equatable.dart';
import 'package:ftc_application/src/models/route_argument.dart';
import 'package:meta/meta.dart';

@immutable
abstract class HomeState extends Equatable {
  const HomeState();
  @override
  List<Object> get props => [];
}

class InitialHomeState extends HomeState {}

class HomePageLoading extends HomeState {}

class HomePageLoaded extends HomeState {
  final RouteArgument homePageInfo;

  HomePageLoaded({this.homePageInfo}) : assert(homePageInfo != null);
}
