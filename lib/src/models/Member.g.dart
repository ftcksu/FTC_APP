// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Member.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Member _$MemberFromJson(Map<String, dynamic> json) {
  return Member(
      id: json['id'] as int,
      name: json['name'] as String,
      phoneNumber: json['phone_number'] as String,
      bio: json['bio'] as String,
      points: json['points'] as int,
      rank: json['user_rank'] as int,
      role: json['role'] as String,
      hidden: json['hidden'] as bool,
      deviceToken: json['device_token'] as String,
      hasProfileImage: json['profile_image'] == null ? false : true);
}

Map<String, dynamic> _$MemberToJson(Member instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'phoneNumber': instance.phoneNumber,
      'bio': instance.bio,
      'points': instance.points,
      'role': instance.role,
      'user_rank': instance.rank,
    };
