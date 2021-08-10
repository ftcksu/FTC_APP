import 'package:ftc_application/src/models/Member.dart';
import 'package:ftc_application/src/models/Task.dart';
import 'package:json_annotation/json_annotation.dart';
part 'Job.g.dart';

@JsonSerializable()
class Job {
  int id = 0;
  String title = "";
  @JsonKey(name: 'user')
  Member assignedMember = Member.initial();
  String description = "";
  @JsonKey(ignore: true)
  List<Task> tasks = [];
  String jobType = "";
  @JsonKey(name: 'event_status')
  bool eventStatus = false;
  int readyTasks = 0;
  int waitingTasks = 0;

  Job(
      {required this.id,
      required this.title,
      required this.assignedMember,
      required this.jobType,
      required this.readyTasks,
      required this.waitingTasks,
      required this.eventStatus});

  Job.initial();

  factory Job.fromJson(Map<String, dynamic> json) => _$JobFromJson(json);
  Map<String, dynamic> toJsonNoTasks() => _$JobToJsonNT(this);
  Map<String, dynamic> toJson() => _$JobToJson(this);
  Map<String, dynamic> toJsonNoD() => _$JobToJsonNoD(this);
}
