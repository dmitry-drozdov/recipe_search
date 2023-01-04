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
