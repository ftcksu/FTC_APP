import 'package:ftc_application/src/models/Event.dart';
import 'package:json_annotation/json_annotation.dart';

part 'Member.g.dart';

@JsonSerializable(nullable: false)
class Member {
  int id;
  String name;
  @JsonKey(name: 'phone_number')
  String phoneNumber;
  String bio;
  String role;
  int points;
  @JsonKey(name: 'user_rank')
  int rank;
  bool hidden;
  @JsonKey(name: 'device_token')
  String deviceToken;

  @JsonKey(ignore: true)
  List<Event> participatedEvents;
  @JsonKey(ignore: true)
  bool hasProfileImage;

  Member(
      {this.id,
      this.name,
      this.phoneNumber,
      this.bio,
      this.points,
      this.rank,
      this.hidden,
      this.deviceToken,
      this.role,
      this.participatedEvents,
      this.hasProfileImage});

  factory Member.fromJson(Map<String, dynamic> json) => _$MemberFromJson(json);
  Map<String, dynamic> toJson() => _$MemberToJson(this);
}
