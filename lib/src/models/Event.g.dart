// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Event _$EventFromJson(Map<String, dynamic> json) {
  return Event(
    id: json['id'] as int,
    title: json['title'] as String,
    description: json['description'] as String,
    date: DateTime.parse(json['date'] as String),
    whatsAppLink: json['whats_app_link'] as String,
    full: json['full'] as bool,
    maxUsers: json['max_users'] as int,
    finished: json['finished'] as bool,
    location: json['location'] as String,
    leader: Member.fromJson(json['leader'] as Map<String, dynamic>),
  );
}


Map<String, dynamic> _$EventToJson(Event instance) => <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'date': instance.date.toIso8601String(),
      'whats_app_link': instance.whatsAppLink,
      'max_users': instance.maxUsers,
      'location': instance.location,
      'leader_id': instance.leader.id,
    };
Map<String, dynamic> _$EventToJsonNoMembers(Event instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'date': instance.date.toIso8601String(),
      'whats_app_link': instance.whatsAppLink,
      'max_users': instance.maxUsers,
      'location': instance.location,
      'leader': instance.leader.id,
    };
