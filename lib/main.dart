import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:recipe_search/utils/auth.dart';
import 'package:recipe_search/utils/firestore.dart';
import 'package:recipe_search/utils/internet_checker.dart';
import 'package:recipe_search/view/landing/landing.dart';

final snackbarKey = GlobalKey<ScaffoldMessengerState>();
final locator = GetIt.instance;

Future<void> init() async {
  WidgetsFlutterBinding.ensureInitialized();
  final firebaseApp = await Firebase.initializeApp();
  final internetChecker = await InternetChecker.create();
  locator.registerSingleton(internetChecker);
  locator.registerSingleton(FirebaseStorage());
  locator.registerSingleton(Authentication(firebaseApp));
}

void main() {
  init().then((value) => runApp(const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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
