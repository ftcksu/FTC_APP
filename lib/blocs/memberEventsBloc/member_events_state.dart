import 'package:equatable/equatable.dart';
import 'package:ftc_application/src/models/Event.dart';

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

  EventsLoaded({required this.events});
}

class CurrentMemberEventPageLoading extends MemberEventsState {}

class CurrentMemberEventPageLoaded extends MemberEventsState {
  final List<Event> events;

  CurrentMemberEventPageLoaded({required this.events});
}

class MemberEventsLoading extends MemberEventsState {}

class MemberEventsLoaded extends MemberEventsState {
  final List<Event> memberEvents;

  MemberEventsLoaded({required this.memberEvents});
}
