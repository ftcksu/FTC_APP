import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class PointsEvent extends Equatable {
  const PointsEvent();
  @override
  List<Object> get props => [];
}

class GetPointsPage extends PointsEvent {}

class RefreshPointsPage extends PointsEvent {}
