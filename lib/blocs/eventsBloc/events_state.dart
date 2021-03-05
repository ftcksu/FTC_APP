import 'package:equatable/equatable.dart';
import 'package:ftc_application/src/models/route_argument.dart';
import 'package:meta/meta.dart';

@immutable
abstract class EventsState extends Equatable {
  const EventsState();
  @override
  List<Object> get props => [];
}

class InitialEventsState extends EventsState {}

class EventPageLoading extends EventsState {}

class EventPageLoaded extends EventsState {
  final RouteArgument events;

  EventPageLoaded({this.events}) : assert(events != null);
}

class EventUserBeingAdded extends EventsState {}

class EventUserAdded extends EventsState {
  final String response;

  EventUserAdded({this.response}) : assert(response != null);
}
