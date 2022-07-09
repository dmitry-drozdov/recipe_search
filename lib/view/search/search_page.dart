import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_search/helpers/extensions/edge_extension.dart';
import 'package:recipe_search/helpers/linear_loading.dart';
import 'package:recipe_search/view/recipe/recipe_list.dart';
import 'package:recipe_search/view/search/params.dart';
import 'package:recipe_search/viewmodels/recipe_viewmodel.dart';
import 'package:recipe_search/viewmodels/viewmodel_provider.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final recipeViewModel = ViewModelProvider.getOrCreate(key: recipeKey, create: () => RecipeViewModel.create());
  final controller = TextEditingController();
  final expandableController = ExpandableController();
  String searchText = '';

  void _loadRecipes() {
    final trimmedSearch = searchText.trim();
    if (trimmedSearch != recipeViewModel.searchSettings.search) {
      recipeViewModel.updateSearchSettings(newSearch: trimmedSearch);
    }
    recipeViewModel.loadRecipesFirstPage();
  }

  @override
  void initState() {
    super.initState();
    recipeViewModel.startUIListening((event) {
      switch (event) {
        case RecipeEvent.openRecipe:
          break;
        case RecipeEvent.hideParams:
          if (expandableController.expanded) {
            expandableController.expanded = false;
          }
          break;
        case RecipeEvent.openAllParams:
          if (!mounted) return;
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => Params(
                key: Key('params${recipeViewModel.searchSettings.hashCode}'),
                screenMode: ScreenMode.full,
                onApply: _loadRecipes,
                recipeViewModel: recipeViewModel,
              ),
            ),
          );
          break;
      }
    });
  }

  @override
  void dispose() {
    recipeViewModel.stopUIListening();
    controller.dispose();
    expandableController.dispose();
    super.dispose();
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
                  padding: const EdgeInsets.fromLTRB(8, 0, 8, 4),
                  child: TextField(
                    controller: controller,
                    onChanged: (value) => searchText = value,
                    onEditingComplete: _loadRecipes,
                    textInputAction: TextInputAction.search,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 4),
                child: TextButton(
                  child: const Text('Search'),
                  onPressed: _loadRecipes,
                ),
              ),
            ],
          ),
          ChangeNotifierProvider.value(
            value: recipeViewModel,
            child: Consumer<RecipeViewModel>(
              builder: (_, viewModel, ___) {
                return buildParams();
              },
            ),
          ),
          const Flexible(child: RecipeList()),
        ],
      ),
    );
  }

  Widget buildParams() {
    return ExpandablePanel(
      header: const Text('Params', style: TextStyle(fontSize: 18)),
      theme: ExpandableThemeData(
        headerAlignment: ExpandablePanelHeaderAlignment.center,
        iconColor: Theme.of(context).primaryColor,
        animationDuration: const Duration(milliseconds: 400),
        scrollAnimationDuration: const Duration(milliseconds: 400),
      ),
      controller: expandableController,
      collapsed: Container(),
      expanded: Params(
        recipeViewModel: recipeViewModel,
        onApply: _loadRecipes,
        screenMode: ScreenMode.part,
      ),
    ).padding8880;
  }
}
