import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class MemberEvent extends Equatable {
  const MemberEvent();
  @override
  List<Object> get props => [];
}

class GetMembers extends MemberEvent {}

class GetEventCreation extends MemberEvent {
  final int eventId;

  GetEventCreation({required this.eventId});
}

class GetMember extends MemberEvent {}

class GetEventMembers extends MemberEvent {
  final int eventId;

  GetEventMembers({required this.eventId});
}

class UpdateMember extends MemberEvent {
  final Map<String, dynamic> payload;
  UpdateMember({required this.payload});
}

class ChangeMOTD extends MemberEvent {
  final Map<String, dynamic> payload;
  ChangeMOTD({required this.payload});
}

class AddImage extends MemberEvent {
  final File image;

  AddImage({required this.image});
}

class RefreshMember extends MemberEvent {}
