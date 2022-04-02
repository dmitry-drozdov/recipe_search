import 'package:flutter/material.dart';

import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:recipe_search/view/search/search_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return KeyboardDismisser(
      child: MaterialApp(
        title: 'Recipe Search',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const SearchPage(title: 'Recipe Search'),
      ),
    );
  }
}

