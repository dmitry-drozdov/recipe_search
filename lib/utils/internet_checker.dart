import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:recipe_search/helpers/app_colors.dart';
import 'package:recipe_search/helpers/extensions/internet_status_extension.dart';

import '../helpers/consts.dart';
import '../main.dart';

class InternetChecker {
  late InternetConnectionStatus lastStatus;

  static Future<InternetChecker> create() async {
    final checker = InternetChecker();
    checker.lastStatus = await InternetConnectionChecker().connectionStatus;
    checker.onStatusChange.listen(checker._onInternetStatusChanged);
    return checker;
  }

  bool get connected => lastStatus.connected;
  bool get disconnected => lastStatus.disconnected;

  Stream<InternetConnectionStatus> get onStatusChange => _internetChecker.onStatusChange;

  final _internetChecker = InternetConnectionChecker.createInstance(
    checkTimeout: Duration(seconds: 5),
    checkInterval: Duration(seconds: 5),
  );

  void _onInternetStatusChanged(InternetConnectionStatus status) {
    log('Internet Status Changed $status');

    if (lastStatus == status) {
      return; // do not show one msg twice
    }

    final connected = status.connected;
    final msg = connected
        ? 'Data connection is available'
        : 'You are disconnected from the internet. Some features may not work';

    snackbarKey.currentState
      ?..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(msg, style: TextStyle(fontSize: 16)),
          backgroundColor: AppColors.blueBorder,
          duration: connected ? snackbarShortDuration : snackbarDuration,
          action: SnackBarAction(
            label: "⨉",
            textColor: Colors.white,
            onPressed: () {
              snackbarKey.currentState?.hideCurrentSnackBar();
            },
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(connected ? 10.0 : 15.0),
          ),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.fromLTRB(7, 0, 7, 10),
        ),
      );

    lastStatus = status;
  }
}
