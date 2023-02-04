// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppUser _$AppUserFromJson(Map<String, dynamic> json) => AppUser._(
      deviceId: json['deviceId'] as String,
      uid: json['uid'] as String?,
      displayName: json['displayName'] as String?,
    );

Map<String, dynamic> _$AppUserToJson(AppUser instance) => <String, dynamic>{
      'deviceId': instance.deviceId,
      'uid': instance.uid,
      'displayName': instance.displayName,
    };
