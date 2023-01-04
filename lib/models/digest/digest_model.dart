import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:recipe_search/helpers/app_colors.dart';

import '../../view/recipe/helper/rich_row_widget.dart';

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
  @JsonKey(fromJson: digestFromJson)
  final List<Digest> sub;

  Digest({
    required this.label,
    required this.tag,
    this.schemaOrgTag,
    required this.total,
    required this.hasRDI,
    required this.daily,
    required this.unit,
    required this.sub,
  });

  factory Digest.fromJson(Map<String, dynamic> json) => _$DigestFromJson(json);

  Widget row({bool indent = false, int? services}) {
    final _total = convertToInt(total, services);
    final _daily = convertToInt(daily, services);
    return RichRow(
      color: indent ? null : AppColors.white,
      padding: indent ? const EdgeInsets.fromLTRB(24, 4, 8, 4) : null,
      left: label,
      right: "$_total $unit",
      rightTooltip: _daily > 0 ? "$_daily% Daily Value" : null,
    );
  }

  int convertToInt(double value, int? services) {
    if (services != null && services != 0) {
      return (value / services).round();
    }
    return value.round();
  }
}

List<Digest> digestFromJson(List<dynamic>? json) {
  return json?.map((e) => Digest.fromJson(e as Map<String, dynamic>)).toList() ?? [];
}
