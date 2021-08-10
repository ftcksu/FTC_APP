import 'package:ftc_application/src/models/Member.dart';
import 'package:json_annotation/json_annotation.dart';
part 'Event.g.dart';

@JsonSerializable()
class Event {
  int id = 0;
  String title = "";
  String description = "";
  DateTime date = DateTime.now();
  bool full = false;
  @JsonKey(name: 'whats_app_link')
  String whatsAppLink = "";
  @JsonKey(name: 'max_users')
  int maxUsers = 0;
  String location = "";
  bool finished = false;
  Member leader = Member.initial();

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.full,
    required this.whatsAppLink,
    required this.maxUsers,
    required this.finished,
    required this.leader,
    required this.location,
  });

  Event.initial();

  factory Event.fromJson(Map<String, dynamic> json) => _$EventFromJson(json);
  Map<String, dynamic> toJson() => _$EventToJson(this);
  Map<String, dynamic> toJsonNoMembers() => _$EventToJsonNoMembers(this);
}
