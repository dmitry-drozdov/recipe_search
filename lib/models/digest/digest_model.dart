import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:recipe_search/helpers/app_colors.dart';
import 'package:recipe_search/helpers/extensions/double_extension.dart';

import '../../view/recipe/helper/rich_row_widget.dart';

part 'digest_model.g.dart';

@JsonSerializable(explicitToJson: true, createToJson: true)
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
    required this.sub,
  });

  List<Digest> get subOrEmpty => sub ?? <Digest>[];

  factory Digest.fromJson(Map<String, dynamic> json) => _$DigestFromJson(json);

  Map<String, dynamic> toJson() => _$DigestToJson(this);

  Widget row({bool indent = false, int? services}) {
    final dTotal = convert(total, services);
    final dDaily = convert(daily, services);
    return RichRow(
      color: indent ? null : AppColors.white,
      padding: indent ? const EdgeInsets.fromLTRB(24, 4, 8, 4) : null,
      left: label,
      right: "${dTotal.trimZero()} $unit",
      rightTooltip: dDaily > 0 ? "${dDaily.trimZero()}% Daily Value" : null,
    );
  }

  double convert(double value, int? services) {
    if (services != null && services != 0) {
      value /= services;
    }
    var precision = 0;
    if (value < 10) precision = 1;
    if (value < 1) precision = 2;
    return value.toPrecision(precision);
  }
}
