import 'package:equatable/equatable.dart';

abstract class MemberEventsEvent extends Equatable {
  const MemberEventsEvent();
  @override
  List<Object> get props => [];
}

class GetEvents extends MemberEventsEvent {}

class GetMemberEvents extends MemberEventsEvent {
  final int memberId;

  GetMemberEvents({this.memberId}) : assert(memberId != null);
}

class GetCurrentMemberEvents extends MemberEventsEvent {}

class MemberRefreshEvents extends MemberEventsEvent {}

class RefreshCurrentMemberEvents extends MemberEventsEvent {}
