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
    return row();
  }

  Widget row({bool indent = false}) {
    String? rightTooltip;
    if (daily > 0) {
      rightTooltip = "${daily.round()}% Daily Value";
    }

    return RichRow(
      color: indent ? AppColors.white : null,
      left: label,
      right: "${total.round()} $unit",
      rightTooltip: rightTooltip,
    );
  }
}

List<Digest> digestFromJson(List<dynamic>? json) {
  return json?.map((e) => Digest.fromJson(e as Map<String, dynamic>)).toList() ?? [];
}
