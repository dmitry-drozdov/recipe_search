import 'dart:async';
import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:recipe_search/utils/auth.dart';
import 'package:recipe_search/utils/firestore.dart';
import 'package:recipe_search/view/landing/landing.dart';

import 'helpers/consts.dart';

final snackbarKey = GlobalKey<ScaffoldMessengerState>();
final locator = GetIt.instance;
final internetChecker = InternetConnectionChecker.createInstance(
  checkTimeout: const Duration(seconds: 5),
  checkInterval: const Duration(seconds: 5),
);

Future<void> init() async {
  WidgetsFlutterBinding.ensureInitialized();
  final firebaseApp = await Firebase.initializeApp();
  locator.registerSingleton(FirebaseStorage());
  locator.registerSingleton(Authentication(firebaseApp));
}

void main() {
  init().then((value) => runApp(const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final StreamSubscription<InternetConnectionStatus> listener;
  InternetConnectionStatus lastStatus = InternetConnectionStatus.connected;

  void onInternetStatusChanged(InternetConnectionStatus status) {
    log('Internet Status Changed $status');
    if (!mounted || lastStatus == status) {
      return;
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
          backgroundColor: Theme.of(context).primaryColor,
          duration: connected ? snackbarShortDuration : snackbarDuration,
        ),
      );

    lastStatus = status;
  }

  @override
  void initState() {
    super.initState();
    listener = internetChecker.onStatusChange.listen(onInternetStatusChanged);
  }

  @override
  void dispose() {
    listener.cancel();
    super.dispose();
  }

// This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return KeyboardDismisser(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Recipe Search',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Landing(title: 'Recipe Search Landing'),
        scaffoldMessengerKey: snackbarKey,
      ),
    );
  }
}
