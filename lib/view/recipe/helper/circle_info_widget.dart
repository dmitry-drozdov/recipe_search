import 'package:flutter/material.dart';

const circleSize = 90.0;

class CircleInfo extends StatelessWidget {
  final String title;
  final String value;
  final String? subValue;
  final Color borderColor;

  const CircleInfo({
    Key? key,
    required this.title,
    required this.value,
    this.subValue,
    required this.borderColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: borderColor.withOpacity(0.05),
        border: Border.all(color: borderColor, width: 2),
        borderRadius: const BorderRadius.all(Radius.circular(100)),
      ),
      height: circleSize,
      width: circleSize,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
          ),
          if (subValue != null)
            Text(
              subValue!,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
            ),
          Text(
            title,
            style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
