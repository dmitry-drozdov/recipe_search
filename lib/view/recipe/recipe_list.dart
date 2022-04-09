import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_search/view/recipe/recipe_card.dart';
import 'package:recipe_search/view/recipe/recipe_full.dart';
import 'package:recipe_search/viewmodels/recipe_viewmodel.dart';
import 'package:recipe_search/viewmodels/viewmodel_provider.dart';

class RecipeList extends StatefulWidget {
  const RecipeList({Key? key}) : super(key: key);

  @override
  State<RecipeList> createState() => _RecipeListState();
}

class _RecipeListState extends State<RecipeList> {
  final recipeViewModel = ViewModelProvider.get<RecipeViewModel>(recipeKey);

  @override
  void initState() {
    super.initState();
    recipeViewModel.startUIListening((event) {
      switch (event) {
        case RecipeEvent.openRecipe:
          final id = recipeViewModel.currentRecipeId;
          if (id == null) {
            throw Exception('Cannot open recipe full page. It was null');
          }
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => RecipeFull(key: Key('recipeFull$id'), id: id),
            ),
          );
          break;
        case RecipeEvent.hideParams:
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: recipeViewModel,
      child: Consumer<RecipeViewModel>(
        builder: (_, viewModel, ___) {
          if (viewModel.count == 0 && !recipeViewModel.loading) {
            return noResult();
          }
          return ListView.builder(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            itemBuilder: (ctx, i) {
              if (i == viewModel.items.length - 1 && !viewModel.loading) {
                WidgetsBinding.instance?.addPostFrameCallback((_) {
                  viewModel.loadRecipesNextPage();
                });
              }
              final element = viewModel.items[i];
              final id = element.id;
              return RecipeCard(
                key: Key('recipeCard$id'),
                recipe: element,
                onTap: viewModel.processingIds.contains(id) ? null : () => viewModel.onRecipeTap(id: id),
              );
            },
            itemCount: viewModel.items.length,
          );
        },
      ),
    );
  }

  Widget noResult() {
    final text = recipeViewModel.searchSettings.empty ? "Please enter what do you to find" : "No results found";
    return Align(
      alignment: Alignment.center,
      child: Column(
        children: [
          Icon(
            Icons.search,
            size: 220,
            color: Theme.of(context).primaryColor.withOpacity(0.3),
          ),
          Text(
            text,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
