import 'package:ftc_application/src/models/Event.dart';
import 'package:json_annotation/json_annotation.dart';

part 'Member.g.dart';

@JsonSerializable()
class Member {
  int id = 0;
  String name = "";
  @JsonKey(name: 'phone_number')
  String phoneNumber = "";
  String bio = "";
  String role = "";
  int points = 0;
  @JsonKey(name: 'user_rank')
  int rank = 0;
  bool hidden = false;
  @JsonKey(name: 'device_token')
  String deviceToken = "";

  @JsonKey(ignore: true)
  List<Event> participatedEvents = [];
  @JsonKey(ignore: true)
  bool hasProfileImage = false;

  Member(
      {required this.id,
      required this.name,
      required this.phoneNumber,
      required this.bio,
      required this.points,
      required this.rank,
      required this.hidden,
      required this.deviceToken,
      required this.role,
      required this.hasProfileImage});

  Member.initial();

  factory Member.fromJson(Map<String, dynamic> json) => _$MemberFromJson(json);
  Map<String, dynamic> toJson() => _$MemberToJson(this);
}
