import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_search/view/recipe/recipe_card.dart';

import '../../viewmodels/recipe_viewmodel.dart';
import '../../viewmodels/viewmodel_provider.dart';

class FavoriteRecipes extends StatefulWidget {
  @override
  State<FavoriteRecipes> createState() => _FavoriteRecipesState();
}

class _FavoriteRecipesState extends State<FavoriteRecipes> {
  final recipeViewModel = ViewModelProvider.get<RecipeViewModel>(recipeKey);

  @override
  void initState() {
    super.initState();
    recipeViewModel.loadFavoriteRecipes();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: recipeViewModel,
      child: Consumer<RecipeViewModel>(
        builder: (_, viewModel, ___) {
          // if (viewModel.count == 0 && !recipeViewModel.loading) {
          //   return noResult();
          // }
          return ListView.builder(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            itemBuilder: (ctx, i) {
              final element = viewModel.favoriteRecipes[i];
              final id = element.id;
              return RecipeCard(
                key: Key('recipeCard$id'),
                recipe: element,
                onTap: viewModel.processingIds.contains(id) ? null : () => viewModel.onRecipeTap(id: id),
                viewModel: viewModel,
              );
            },
            itemCount: viewModel.favoriteRecipes.length,
          );
        },
      ),
    );
  }
}
