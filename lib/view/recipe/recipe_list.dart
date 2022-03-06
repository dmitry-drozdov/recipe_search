import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_search/view/recipe/recipe_card.dart';
import 'package:recipe_search/viewmodels/recipe_viewmodel.dart';
import 'package:recipe_search/viewmodels/viewmodel_provider.dart';

class RecipeList extends StatelessWidget {
  final recipeViewModel = ViewModelProvider.get<RecipeViewModel>(recipeKey);

  RecipeList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: recipeViewModel,
      child: Consumer<RecipeViewModel>(
        builder: (_, viewModel, ___) {
          return Stack(
            children: [
              ListView.builder(
                itemBuilder: (ctx, i) {
                  if (i == viewModel.items.length - 1 && !viewModel.loading) {
                    WidgetsBinding.instance?.addPostFrameCallback((_){
                      viewModel.loadRecipes();
                    });
                  }
                  return RecipeCard(recipe: viewModel.items[i]);
                },
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
