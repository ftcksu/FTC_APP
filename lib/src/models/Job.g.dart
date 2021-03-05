// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Job.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Job _$JobFromJson(Map<String, dynamic> json) {
  return Job(
      id: json['id'] as int,
      title: json['title'] as String,
      assignedMember: Member.fromJson(json['user'] as Map<String, dynamic>),
      jobType: json['job_type'] as String,
      eventStatus: json['event_status'] as bool,
      readyTasks: json['tasks_count']['READY'] as int,
      waitingTasks: json['tasks_count']['WAITING'] as int);
}

Map<String, dynamic> _$JobToJsonNT(Job instance) => <String, dynamic>{
      'title': instance.title,
      'user': instance.assignedMember.id,
      'description': instance.description,
      'job_type': instance.jobType,
    };

Map<String, dynamic> _$JobToJson(Job instance) => <String, dynamic>{
      'title': instance.title,
      'user': instance.assignedMember.id,
      'description': instance.description,
      'tasks': instance.tasks,
      'job_type': instance.jobType,
    };
Map<String, dynamic> _$JobToJsonNoD(Job instance) => <String, dynamic>{
      'title': instance.title,
      'user': instance.assignedMember.id,
      'tasks': instance.tasks,
      'job_type': instance.jobType,
    };
