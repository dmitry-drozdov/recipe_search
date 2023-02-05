// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserSettings _$UserSettingsFromJson(Map<String, dynamic> json) => UserSettings(
      askBeforeRemoving: json['askBeforeRemoving'] as bool,
      lastSearch: json['lastSearch'] == null
          ? null
          : SearchSettings.fromJson(json['lastSearch'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UserSettingsToJson(UserSettings instance) =>
    <String, dynamic>{
      'askBeforeRemoving': instance.askBeforeRemoving,
      'lastSearch': instance.lastSearch?.toJson(),
    };
