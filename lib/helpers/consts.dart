import 'package:flutter/material.dart';

import 'app_colors.dart';

final placeholder = Icon(Icons.food_bank_outlined, color: AppColors.greyMedium, size: 65);
final placeholderMedium = Icon(Icons.food_bank_outlined, color: AppColors.greyMedium, size: 200);
final placeholderLarge = Icon(Icons.food_bank_outlined, color: AppColors.greyMedium, size: 260);

const listMarker = ' • ';

const mainFont = TextStyle(fontSize: 18);

final numberPickerShape = RoundedRectangleBorder(side: BorderSide(color: AppColors.blueBorder, width: 1.8));

final buttonSize = MaterialStateProperty.all(const Size(250, 40));
final buttonShape = MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)));
final buttonColor = MaterialStateProperty.all(AppColors.white);

final signButtonStyle = ButtonStyle(
  backgroundColor: buttonColor,
  shape: buttonShape,
  minimumSize: buttonSize,
  maximumSize: buttonSize,
);

final alertTextStyle = TextStyle(color: AppColors.blueBorder, fontWeight: FontWeight.w500, height: 1.5);

final tooltipDecoration = BoxDecoration(
  color: AppColors.blueBorder,
  borderRadius: const BorderRadius.all(Radius.circular(5.0)),
);

const snackbarDuration = Duration(seconds: 8);
const snackbarShortDuration = Duration(seconds: 5);
