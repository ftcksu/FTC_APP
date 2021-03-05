import 'package:equatable/equatable.dart';
import 'package:ftc_application/src/models/Member.dart';
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
  final List<Member> members;
  PointsPageLoaded({this.members}) : assert(members != null);
}
