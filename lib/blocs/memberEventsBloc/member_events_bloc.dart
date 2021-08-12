import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:ftc_application/repositories/ftc_repository.dart';
import 'package:ftc_application/src/models/Event.dart';
import './bloc.dart';

class MemberEventsBloc extends Bloc<MemberEventsEvent, MemberEventsState> {
  final FtcRepository ftcRepository;
  MemberEventsBloc({required this.ftcRepository})
      : super(InitialMemberEventsState());
  MemberEventsState get initialState => InitialMemberEventsState();

  @override
  Stream<MemberEventsState> mapEventToState(
    MemberEventsEvent event,
  ) async* {
    if (event is GetEvents) {
      yield* _mapGetEvents();
    } else if (event is GetMemberEvents) {
      yield* _mapGetMemberEvents(event.memberId);
    } else if (event is GetCurrentMemberEvents) {
      yield* _mapGetCurrentMemberEvents();
    }

    if (event is MemberRefreshEvents) {
      yield* _mapGetEvents();
    }
    if (event is RefreshCurrentMemberEvents) {
      yield* _mapGetCurrentMemberEvents();
    }
  }

  Stream<MemberEventsState> _mapGetEvents() async* {
    yield EventsLoading();
    List<Event> events = await ftcRepository.getAdminEvents();
    yield EventsLoaded(events: events);
  }

  Stream<MemberEventsState> _mapGetMemberEvents(int memberId) async* {
    yield MemberEventsLoading();
    List<Event> events = await ftcRepository.getMemberEvents(memberId);
    yield MemberEventsLoaded(memberEvents: events);
  }

  Stream<MemberEventsState> _mapGetCurrentMemberEvents() async* {
    yield CurrentMemberEventPageLoading();
    final List<Event> events =
        await ftcRepository.getCurrentMemberOwnedEvents();
    yield CurrentMemberEventPageLoaded(events: events);
  }
}
