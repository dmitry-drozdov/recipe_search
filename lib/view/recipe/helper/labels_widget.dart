import 'package:flutter/material.dart';

import '../../../helpers/consts.dart';

class Labels extends StatelessWidget {
  final List<String> values;
  final double? fontSize;
  final Color color;
  final FontWeight fontWeight;

  const Labels({
    Key? key,
    required this.values,
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
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue, width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: Tooltip(
              message: text,
              decoration: tooltipDecoration,
              triggerMode: TooltipTriggerMode.tap,
              child: Text(
                text,
                style: style,
                maxLines: 1,
                overflow: TextOverflow.fade,
                softWrap: false,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
