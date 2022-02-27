import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_search/view/recipe/recipe_card.dart';
import 'package:recipe_search/viewmodels/recipe_viewmodel.dart';
import 'package:recipe_search/viewmodels/viewmodel_provider.dart';

class RecipeList extends StatelessWidget {
  final recipeViewModel = ViewModelProvider.get<RecipeViewModel>(recipeKey);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: recipeViewModel,
      child: Consumer<RecipeViewModel>(
        builder: (_, viewModel, ___) {
          return Stack(
            children: [
              ListView.builder(
                itemBuilder: (ctx, i) => RecipeCard(recipe: viewModel.items[i]),
                itemCount: viewModel.items.length,
              ),
              if (viewModel.loading)
                Container(
                  color: Colors.transparent,
                  width: double.infinity,
                  height: double.infinity,
                  child: const Center(child: CircularProgressIndicator()),
                ),
            ],
          );
        },
      ),
    );
  }
}
