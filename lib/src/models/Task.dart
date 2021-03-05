import 'package:ftc_application/src/models/Member.dart';
import 'package:json_annotation/json_annotation.dart';
part 'Task.g.dart';

@JsonSerializable(nullable: false)
class Task {
  int id;
  String description;
  int points;
  @JsonKey(name: 'approval_status')
  String approvalStatus;
  @JsonKey(ignore: true)
  Member assignedMember;

  Task(
      {this.id,
      this.description,
      this.points,
      this.approvalStatus,
      this.assignedMember});

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);
  Map<String, dynamic> toJson() => _$TaskToJson(this);
}
