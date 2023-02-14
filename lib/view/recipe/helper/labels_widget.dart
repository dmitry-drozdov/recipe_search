import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../../../helpers/app_colors.dart';

class Labels extends StatelessWidget {
  final List<String> values;
  final List<String> selectedValues;
  final double? fontSize;
  final Color color;
  final FontWeight fontWeight;

  const Labels({
    Key? key,
    required this.values,
    this.selectedValues = const <String>[],
    this.fontSize = 18,
    this.color = Colors.black,
    this.fontWeight = FontWeight.normal,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    );

    values.sort((a, b) => a.length.compareTo(b.length));

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Wrap(
        spacing: 0,
        runSpacing: 9,
        alignment: WrapAlignment.start,
        children: values.map((e) => textInBorder(context, e, style)).toList(),
      ),
    );
  }

  Widget textInBorder(BuildContext context, String text, TextStyle style) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      padding: const EdgeInsets.symmetric(horizontal: 3),
      width: MediaQuery.of(context).size.width / 3.3,
      height: 26,
      decoration: BoxDecoration(
        color: selectedValues.contains(text) ? AppColors.lightestBlueChip : null,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.blueBorder, width: 1),
      ),
      child: Align(
        alignment: Alignment.center,
        child: AutoSizeText(
          text,
          textAlign: TextAlign.center,
          style: style,
          overflow: TextOverflow.fade,
          softWrap: false,
          maxLines: 1,
        ),
      ),
    );
  }
}
