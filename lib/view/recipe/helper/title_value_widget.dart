import 'package:flutter/material.dart';
import 'package:recipe_search/helpers/app_colors.dart';

class TitleValue extends StatelessWidget {
  final String title;
  final String value;
  final Color? color;

  TitleValue({
    Key? key,
    required this.title,
    required this.value,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 2),
      padding: EdgeInsets.all(8.0),
      color: color ?? AppColors.indigoTitle,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
          Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400)),
        ],
      ),
    );
  }
}
