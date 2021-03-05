import 'package:equatable/equatable.dart';
import 'package:ftc_application/src/models/Event.dart';
import 'package:ftc_application/src/models/route_argument.dart';

abstract class MemberEventsState extends Equatable {
  const MemberEventsState();
  @override
  List<Object> get props => [];
}

class InitialMemberEventsState extends MemberEventsState {
  @override
  List<Object> get props => [];
}

class EventsLoading extends MemberEventsState {}

class EventsLoaded extends MemberEventsState {
  final List<Event> events;

  EventsLoaded({this.events}) : assert(events != null);
}

class CurrentMemberEventPageLoading extends MemberEventsState {}

class CurrentMemberEventPageLoaded extends MemberEventsState {
  final RouteArgument events;

  CurrentMemberEventPageLoaded({this.events}) : assert(events != null);
}

class MemberEventsLoading extends MemberEventsState {}

class MemberEventsLoaded extends MemberEventsState {
  final List<Event> memberEvents;

  MemberEventsLoaded({this.memberEvents}) : assert(memberEvents != null);
}
