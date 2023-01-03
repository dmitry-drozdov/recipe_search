import 'package:flutter/material.dart';

Widget titleValue({required String title, required String value}) {
  return RichText(
    textAlign: TextAlign.start,
    maxLines: 2,
    overflow: TextOverflow.ellipsis,
    text: TextSpan(
      children: [
        TextSpan(text: title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.indigo)),
        TextSpan(text: value, style: const TextStyle(fontSize: 16, color: Colors.black)),
      ],
    ),
  );
}
