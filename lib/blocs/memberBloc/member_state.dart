import 'package:equatable/equatable.dart';
import 'package:ftc_application/src/models/Member.dart';
import 'package:ftc_application/src/models/route_argument.dart';
import 'package:meta/meta.dart';

@immutable
abstract class MemberState extends Equatable {
  @override
  List<Object> get props => [];
}

class InitialMemberState extends MemberState {}

class GetMembersLoading extends MemberState {}

class GetMembersLoaded extends MemberState {
  final List<Member> members;

  GetMembersLoaded({this.members}) : assert(members != null);
}

class GetEventCreationLoading extends MemberState {}

class GetEventCreationLoaded extends MemberState {
  final RouteArgument argument;

  GetEventCreationLoaded({this.argument}) : assert(argument != null);
}

class GetMemberLoading extends MemberState {}

class GetMemberLoaded extends MemberState {
  final Member member;

  GetMemberLoaded({this.member}) : assert(member != null);
}

class EventMembersLoading extends MemberState {}

class EventMembersLoaded extends MemberState {
  final List<Member> members;

  EventMembersLoaded({this.members}) : assert(members != null);
}
