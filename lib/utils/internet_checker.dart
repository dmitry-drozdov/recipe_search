import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:recipe_search/helpers/app_colors.dart';

import '../helpers/consts.dart';
import '../main.dart';

class InternetChecker {
  late InternetConnectionStatus status;
  InternetConnectionStatus? lastStatus;

  static Future<InternetChecker> create() async {
    final checker = InternetChecker();
    checker.status = await InternetConnectionChecker().connectionStatus;
    checker.onStatusChange.listen(checker._onInternetStatusChanged);
    return checker;
  }

  Stream<InternetConnectionStatus> get onStatusChange => _internetChecker.onStatusChange;

  final _internetChecker = InternetConnectionChecker.createInstance(
    checkTimeout: const Duration(seconds: 5),
    checkInterval: const Duration(seconds: 5),
  );

  void _onInternetStatusChanged(InternetConnectionStatus status) {
    log('Internet Status Changed $status');

    if (lastStatus == null && status == InternetConnectionStatus.connected) {
      return; // do not show connected after login
    }
    if (lastStatus == status) {
      return; // do not show one msg twice
    }

    final connected = status == InternetConnectionStatus.connected;
    final msg = connected
        ? 'Data connection is available'
        : 'You are disconnected from the internet. Some features may not work';

    snackbarKey.currentState
      ?..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(msg, style: const TextStyle(fontSize: 16)),
          backgroundColor: AppColors.blueBorder,
          duration: connected ? snackbarShortDuration : snackbarDuration,
        ),
      );

    lastStatus = status;
  }
}
