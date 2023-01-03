import 'package:flutter/material.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:recipe_search/view/landing/landing.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

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
        home: const Landing(title: 'Recipe Search Landing'),
      ),
    );
  }
}
