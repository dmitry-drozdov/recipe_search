// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'digest_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Digest _$DigestFromJson(Map<String, dynamic> json) => Digest(
      label: json['label'] as String,
      tag: json['tag'] as String,
      schemaOrgTag: json['schemaOrgTag'] as String?,
      total: (json['total'] as num).toDouble(),
      hasRDI: json['hasRDI'] as bool,
      daily: (json['daily'] as num).toDouble(),
      unit: json['unit'] as String,
      sub: (json['sub'] as List<dynamic>?)
          ?.map((e) => Digest.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DigestToJson(Digest instance) => <String, dynamic>{
      'label': instance.label,
      'tag': instance.tag,
      'schemaOrgTag': instance.schemaOrgTag,
      'total': instance.total,
      'hasRDI': instance.hasRDI,
      'daily': instance.daily,
      'unit': instance.unit,
      'sub': instance.sub?.map((e) => e.toJson()).toList(),
    };
