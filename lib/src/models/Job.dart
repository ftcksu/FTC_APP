import 'package:ftc_application/src/models/Member.dart';
import 'package:ftc_application/src/models/Task.dart';
import 'package:json_annotation/json_annotation.dart';
part 'Job.g.dart';

@JsonSerializable(nullable: false)
class Job {
  int id;
  String title;
  @JsonKey(name: 'user')
  Member assignedMember;
  String description;
  @JsonKey(ignore: true)
  List<Task> tasks;
  String jobType;
  @JsonKey(name: 'event_status')
  bool eventStatus;
  int readyTasks;
  int waitingTasks;
  Job(
      {this.id,
      this.title,
      this.assignedMember,
      this.description,
      this.tasks,
      this.jobType,
      this.readyTasks,
      this.waitingTasks,
      this.eventStatus});

  factory Job.fromJson(Map<String, dynamic> json) => _$JobFromJson(json);
  Map<String, dynamic> toJsonNoTasks() => _$JobToJsonNT(this);
  Map<String, dynamic> toJson() => _$JobToJson(this);
  Map<String, dynamic> toJsonNoD() => _$JobToJsonNoD(this);
}
