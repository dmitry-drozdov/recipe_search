import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:provider/provider.dart';
import 'package:recipe_search/helpers/linear_loading.dart';
import 'package:recipe_search/models/enums/diet_label.dart';
import 'package:recipe_search/view/recipe/recipe_list.dart';
import 'package:recipe_search/viewmodels/recipe_viewmodel.dart';
import 'package:recipe_search/viewmodels/viewmodel_provider.dart';
import 'package:expandable/expandable.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ExpandablePanel(
        header: const Padding(
          padding: EdgeInsets.only(left: 10),
          child: Text('Params', style: TextStyle(fontSize: 18)),
        ),
        theme: ExpandableThemeData(
          headerAlignment: ExpandablePanelHeaderAlignment.center,
          iconColor: Theme.of(context).primaryColor,
        ),
        collapsed: Container(),
        expanded: MultiSelectChipField<DietLabel?>(
          items: DietLabel.values.map((e) => MultiSelectItem<DietLabel?>(e, e.view)).toList(),
          title: const Text("Diet labels"),
          headerColor: Colors.blue.withOpacity(0.4),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.blue[700]!, width: 1.8),
          ),
          selectedChipColor: Colors.blue.withOpacity(0.5),
          selectedTextStyle: TextStyle(color: Colors.blue[800]),
          onTap: (values) {
            recipeViewModel.dietLabels = values.map((e) => e as DietLabel).toList();
          },
        ),
      ),
    );
  }
}
