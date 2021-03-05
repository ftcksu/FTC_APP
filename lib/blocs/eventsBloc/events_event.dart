import 'package:equatable/equatable.dart';
import 'package:ftc_application/src/models/Member.dart';
import 'package:ftc_application/src/models/PushNotificationRequest.dart';
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

  AddCurrentMemberToEvent({this.eventId}) : assert(eventId != null);
}

class RemoveCurrentMemberToEvent extends EventsEvent {
  final int eventId;

  RemoveCurrentMemberToEvent({this.eventId}) : assert(eventId != null);
}

class AddMemberToEvent extends EventsEvent {
  final int eventId;
  final int memberId;
  AddMemberToEvent({this.eventId, this.memberId});
}

class RemoveMemberFromEvent extends EventsEvent {
  final int memberId;
  final int eventId;

  RemoveMemberFromEvent({this.memberId, this.eventId});
}

class AddEvent extends EventsEvent {
  final Map<String, dynamic> payload;
  final bool notification;
  AddEvent({this.payload, this.notification});
}

class AddEventWithMembers extends EventsEvent {
  final Map<String, dynamic> payload;
  final List<Member> members;
  final bool notification;
  AddEventWithMembers({this.payload, this.members, this.notification});
}

class ChangeEventStatus extends EventsEvent {
  final int eventId;
  final bool status;
  ChangeEventStatus({this.eventId, this.status});
}

class UpdateEvent extends EventsEvent {
  final int eventId;
  final Map<String, dynamic> payload;

  UpdateEvent({this.payload, this.eventId});
}

class AddNewMembersToEvent extends EventsEvent {
  final List<Member> newMembers;
  final int eventId;

  AddNewMembersToEvent({this.eventId, this.newMembers});
}
