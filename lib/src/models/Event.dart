import 'package:ftc_application/src/models/Member.dart';
import 'package:json_annotation/json_annotation.dart';
part 'Event.g.dart';

@JsonSerializable(nullable: false)
class Event {
  int id;
  String title;
  String description;
  DateTime date;
  bool full;
  @JsonKey(name: 'whats_app_link')
  String whatsAppLink;
  @JsonKey(name: 'max_users')
  int maxUsers;
  String location;
  bool finished;
  Member leader;

  Event({
    this.id,
    this.title,
    this.description,
    this.date,
    this.full,
    this.whatsAppLink,
    this.maxUsers,
    this.finished,
    this.leader,
    this.location,
  });

  factory Event.fromJson(Map<String, dynamic> json) => _$EventFromJson(json);
  Map<String, dynamic> toJson() => _$EventToJson(this);
  Map<String, dynamic> toJsonNoMembers() => _$EventToJsonNoMembers(this);
}
