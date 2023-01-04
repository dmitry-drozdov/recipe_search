import 'package:json_annotation/json_annotation.dart';

part 'digest_model.g.dart';

@JsonSerializable(createToJson: false)
class Digest {
  final String label;
  final String tag;
  final String? schemaOrgTag;
  final double total;
  final bool hasRDI;
  final double daily;
  final String unit;
  final List<Digest>? sub;

  Digest({
    required this.label,
    required this.tag,
    this.schemaOrgTag,
    required this.total,
    required this.hasRDI,
    required this.daily,
    required this.unit,
    this.sub,
  });

  factory Digest.fromJson(Map<String, dynamic> json) => _$DigestFromJson(json);
}
