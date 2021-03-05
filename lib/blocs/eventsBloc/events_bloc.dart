import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:ftc_application/repositories/ftc_repository.dart';
import 'package:ftc_application/src/models/route_argument.dart';
import './bloc.dart';

class EventsBloc extends Bloc<EventsEvent, EventsState> {
  final FtcRepository ftcRepository;
  EventsBloc({@required this.ftcRepository}) : assert(ftcRepository != null);

  @override
  EventsState get initialState => InitialEventsState();

  @override
  Stream<EventsState> mapEventToState(
    EventsEvent event,
  ) async* {
    if (event is GetEventsPage) {
      yield* _mapGetEventsPage();
    }

    if (event is RefreshEvents) {
      yield* _mapGetEventsPage();
    }

    if (event is AddEvent) {
      await ftcRepository.addEvent(event.payload, event.notification);
      yield InitialEventsState();
    }

    if (event is AddEventWithMembers) {
      int id = await ftcRepository.addEvent(event.payload, event.notification);
      await ftcRepository.addMembersToEvent(id, event.members);
      yield InitialEventsState();
    }

    if (event is ChangeEventStatus) {
      await ftcRepository.changeEventStatus(event.eventId, event.status);
      yield InitialEventsState();
    }

    if (event is UpdateEvent) {
      await ftcRepository.updateEvent(event.eventId, event.payload);
      yield InitialEventsState();
    }

    if (event is AddCurrentMemberToEvent) {
      await ftcRepository.joinEvent(event.eventId);
      yield InitialEventsState();
    }

    if (event is RemoveMemberFromEvent) {
      await ftcRepository.removeMemberFromEvent(event.eventId, event.memberId);
      yield InitialEventsState();
    }

    if (event is AddNewMembersToEvent) {
      await ftcRepository.addMembersToEvent(event.eventId, event.newMembers);
      yield InitialEventsState();
    }
  }

  Stream<EventsState> _mapGetEventsPage() async* {
    try {
      yield EventPageLoading();
      final RouteArgument events = await ftcRepository.getEvents();
      yield EventPageLoaded(events: events);
    } catch (e) {
      yield EventPageLoading();
      await ftcRepository.reLogIn();
      yield InitialEventsState();
    }
  }
}
