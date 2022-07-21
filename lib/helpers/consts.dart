import 'package:flutter/material.dart';

final placeholder = Icon(Icons.food_bank_outlined, color: Colors.grey.shade400, size: 65);

final placeholderLarge = Icon(Icons.food_bank_outlined, color: Colors.grey.shade400, size: 260);

const listMarker = ' • ';

const mainFont = TextStyle(fontSize: 18);

final numberPickerShape = RoundedRectangleBorder(side: BorderSide(color: Colors.blue[700]!, width: 1.8));

final buttonSize = MaterialStateProperty.all(const Size(250, 40));
final buttonShape = MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)));
final buttonColor = MaterialStateProperty.all(Colors.white);

final signButtonStyle = ButtonStyle(
  backgroundColor: buttonColor,
  shape: buttonShape,
  minimumSize: buttonSize,
  maximumSize: buttonSize,
);
