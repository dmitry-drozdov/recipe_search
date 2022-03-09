import 'package:flutter/material.dart';

class Value extends StatelessWidget {
  final String value;
  final double? fontSize;

  const Value({
    Key? key,
    required this.value,
    this.fontSize = 18,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(value, style: TextStyle(fontSize: fontSize)),
    );
  }
}