import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_search/helpers/linear_loading.dart';
import 'package:recipe_search/view/recipe/recipe_list.dart';
import 'package:recipe_search/viewmodels/recipe_viewmodel.dart';
import 'package:recipe_search/viewmodels/viewmodel_provider.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';

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
        home: const MyHomePage(title: 'Recipe Search'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final recipeViewModel = ViewModelProvider.getOrCreate(key: recipeKey, create: () => RecipeViewModel.create());
  final controller = TextEditingController();
  String searchText = '';

  void _loadRecipes() {
    recipeViewModel.loadRecipes(text: searchText);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: <Widget>[
          ChangeNotifierProvider.value(
            value: recipeViewModel,
            child: Consumer<RecipeViewModel>(
              builder: (_, viewModel, ___) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                  child: LinearLoading(
                    Theme.of(context).primaryColor,
                    show: recipeViewModel.loading,
                  ),
                );
              },
            ),
          ),
          Row(
            children: [
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8, 4, 8, 8),
                  child: TextField(
                    controller: controller,
                    onChanged: (value) => searchText = value,
                    onEditingComplete: _loadRecipes,
                    textInputAction: TextInputAction.search,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 4, 8, 8),
                child: TextButton(
                  child: const Text('Search'),
                  onPressed: _loadRecipes,
                ),
              ),
            ],
          ),
          const Flexible(child: RecipeList()),
        ],
      ),
    );
  }
}
