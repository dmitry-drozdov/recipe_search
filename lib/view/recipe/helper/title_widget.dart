import 'package:flutter/material.dart';

class TitleWidget extends StatelessWidget {
  final String title;
  final Color? color;
  final FontWeight? fontWeight;

  const TitleWidget({
    Key? key,
    required this.title,
    this.color,
    this.fontWeight = FontWeight.w500,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      color: color ?? Colors.indigo.withOpacity(0.1),
      child: Text(title, style: TextStyle(fontSize: 20, fontWeight: fontWeight)),
    );
  }
}