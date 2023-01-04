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

  Widget get rowMain {
    return row();
  }

  Widget get rowSecond {
    return row(indent: true);
  }

  Widget row({bool indent = false}) {
    return RichRow(
      color: indent ? null : AppColors.white,
      padding: indent ? const EdgeInsets.fromLTRB(24, 4, 8, 4) : null,
      left: label,
      right: "${total.round()} $unit",
      rightTooltip: daily > 0 ? "${daily.round()}% Daily Value" : null,
    );
  }
}

List<Digest> digestFromJson(List<dynamic>? json) {
  return json?.map((e) => Digest.fromJson(e as Map<String, dynamic>)).toList() ?? [];
}
