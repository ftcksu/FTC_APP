import 'package:equatable/equatable.dart';
import 'package:ftc_application/src/models/route_argument.dart';
import 'package:meta/meta.dart';

@immutable
abstract class PointsState extends Equatable {
  const PointsState();
  @override
  List<Object> get props => [];
}

class InitialPointsState extends PointsState {}

class PointsPageLoading extends PointsState {}

class PointsPageLoaded extends PointsState {
  final RouteArgument pointsPageInfo;
  PointsPageLoaded({this.pointsPageInfo}) : assert(pointsPageInfo != null);
}
