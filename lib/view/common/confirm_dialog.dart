import 'package:flutter/material.dart';

import '../../helpers/app_colors.dart';
import '../../helpers/consts.dart';

enum ExitType { cancel, yesNow, yesAlways }

class ConfirmDialog extends StatelessWidget {
  const ConfirmDialog({
    Key? key,
    required this.title,
    required this.content,
    this.yesAlwaysText,
    this.yesNowText = 'Yes',
    this.cancelText = 'Cancel',
  }) : super(key: key);

  final String title;
  final String content;
  final String? yesAlwaysText;
  final String yesNowText;
  final String cancelText;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title, style: alertTextStyle),
      content: Text(content, style: alertTextStyle),
      actions: <Widget>[
        if (yesAlwaysText != null)
          TextButton(
            onPressed: () => Navigator.pop(context, ExitType.yesAlways),
            child: Text(yesAlwaysText!, style: TextStyle(color: AppColors.redText)),
          ),
        TextButton(
          onPressed: () => Navigator.pop(context, ExitType.yesNow),
          child: Text(yesNowText, style: TextStyle(color: AppColors.redLetter)),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, ExitType.cancel),
          child: Text(cancelText, style: alertTextStyle),
        ),
      ],
    );
  }
}
