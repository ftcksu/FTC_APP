import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:ftc_application/repositories/ftc_repository.dart';
import 'package:ftc_application/src/models/Member.dart';
import 'package:ftc_application/src/models/route_argument.dart';
import './bloc.dart';

class MemberBloc extends Bloc<MemberEvent, MemberState> {
  final FtcRepository ftcRepository;
  MemberBloc({@required this.ftcRepository}) : assert(ftcRepository != null);
  @override
  MemberState get initialState => InitialMemberState();

  @override
  Stream<MemberState> mapEventToState(
    MemberEvent event,
  ) async* {
    if (event is GetMembers) {
      yield* _mapGetMembers();
    } else if (event is GetMember) {
      yield* _mapGetMember();
    } else if (event is GetEventMembers) {
      yield* _mapGetEventMembers(event.eventId);
    } else if (event is GetEventCreation) {
      yield* _mapGetEventCreation(event.eventId);
    }

    if (event is UpdateMember) {
      await ftcRepository.updateMember(event.payload);
    }

    if (event is ChangeMOTD) {
      await ftcRepository.addMessageOfTheDay(event.payload);
    }

    if (event is AddImage) {
      await ftcRepository.uploadMemberImage(event.image);
    }

    if (event is RefreshMember) {
      yield* _mapGetMember();
    }
  }

  Stream<MemberState> _mapGetMembers() async* {
    yield GetMembersLoading();
    List<Member> members = await ftcRepository.getMembers(false);
    yield GetMembersLoaded(members: members);
  }

  Stream<MemberState> _mapGetMember() async* {
    yield GetMemberLoading();
    Member member = await ftcRepository.getCurrentMember();
    yield GetMemberLoaded(member: member);
  }

  Stream<MemberState> _mapGetEventMembers(int eventId) async* {
    yield EventMembersLoading();
    final List<Member> members = await ftcRepository.getEventMembers(eventId);
    yield EventMembersLoaded(members: members);
  }

  Stream<MemberState> _mapGetEventCreation(int eventId) async* {
    yield GetEventCreationLoading();
    final List<Member> members = await ftcRepository.getMembers(false);
    if (eventId != null) {
      final List<Member> participatedMembers =
          await ftcRepository.getEventMembers(eventId);
      yield GetEventCreationLoaded(
          argument:
              RouteArgument(argumentsList: [members, participatedMembers]));
    } else {
      yield GetEventCreationLoaded(
          argument: RouteArgument(argumentsList: [members]));
    }
  }
}
