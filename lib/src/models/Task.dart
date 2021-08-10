import 'package:ftc_application/src/models/Member.dart';
import 'package:json_annotation/json_annotation.dart';
part 'Task.g.dart';

@JsonSerializable()
class Task {
  int id = 0;
  String description = "";
  int points = 0;
  @JsonKey(name: 'approval_status')
  String approvalStatus = "";
  @JsonKey(ignore: true)
  Member assignedMember = Member.initial();

  Task({
    required this.id,
    required this.description,
    required this.points,
    required this.approvalStatus,
  });

  Task.assignedTask({
    required this.id,
    required this.description,
    required this.assignedMember,
  });

  Task.submittedTask({
    required this.description,
    required this.approvalStatus,
  });
  Task.initial();

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);
  Map<String, dynamic> toJson() => _$TaskToJson(this);
}
