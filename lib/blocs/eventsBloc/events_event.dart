import 'package:equatable/equatable.dart';
import 'package:ftc_application/src/models/Member.dart';
import 'package:meta/meta.dart';

@immutable
abstract class EventsEvent extends Equatable {
  const EventsEvent();
  @override
  List<Object> get props => [];
}

class GetEventsPage extends EventsEvent {}

class RefreshEvents extends EventsEvent {}

class AddCurrentMemberToEvent extends EventsEvent {
  final int eventId;

  AddCurrentMemberToEvent({required this.eventId});
}

class RemoveCurrentMemberToEvent extends EventsEvent {
  final int eventId;

  RemoveCurrentMemberToEvent({required this.eventId});
}

class AddMemberToEvent extends EventsEvent {
  final int eventId;
  final int memberId;
  AddMemberToEvent({required this.eventId, required this.memberId});
}

class RemoveMemberFromEvent extends EventsEvent {
  final int memberId;
  final int eventId;

  RemoveMemberFromEvent({required this.memberId, required this.eventId});
}

class AddEvent extends EventsEvent {
  final Map<String, dynamic> payload;
  final bool notification;
  AddEvent({required this.payload, required this.notification});
}

class AddEventWithMembers extends EventsEvent {
  final Map<String, dynamic> payload;
  final List<Member> members;
  final bool notification;
  AddEventWithMembers(
      {required this.payload,
      required this.members,
      required this.notification});
}

class ChangeEventStatus extends EventsEvent {
  final int eventId;
  final bool status;
  ChangeEventStatus({required this.eventId, required this.status});
}

class UpdateEvent extends EventsEvent {
  final int eventId;
  final Map<String, dynamic> payload;

  UpdateEvent({required this.payload, required this.eventId});
}

class AddNewMembersToEvent extends EventsEvent {
  final List<Member> newMembers;
  final int eventId;

  AddNewMembersToEvent({required this.eventId, required this.newMembers});
}
