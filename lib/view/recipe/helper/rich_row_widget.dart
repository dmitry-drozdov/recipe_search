import 'package:flutter/material.dart';
import 'package:recipe_search/helpers/app_colors.dart';
import 'package:recipe_search/helpers/consts.dart';

class RichRow extends StatelessWidget {
  final String left;
  final String right;
  final String? rightTooltip;
  final Color? color;
  final FontWeight? fontWeight;
  final EdgeInsets? padding;

  const RichRow({
    Key? key,
    required this.left,
    required this.right,
    this.rightTooltip,
    this.color,
    this.fontWeight = FontWeight.w500,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(fontSize: 20, fontWeight: fontWeight);
    return Container(
      padding: padding ?? const EdgeInsets.all(8.0),
      color: color ?? AppColors.indigoTitle,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(child: Text(left, style: textStyle)),
          Tooltip(
            message: rightTooltip ?? '',
            decoration: tooltipDecoration,
            preferBelow: false,
            triggerMode: TooltipTriggerMode.tap,
            child: Row(
              children: [
                Text(right, style: textStyle),
                const SizedBox(width: 5),
                Icon(
                  Icons.info_outline_rounded,
                  color: rightTooltip != null ? AppColors.blueChip : Colors.transparent,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
