import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_search/view/recipe/recipe_card.dart';

import '../../helpers/widgets/linear_loading.dart';
import '../../viewmodels/recipe_viewmodel.dart';
import '../../viewmodels/viewmodel_provider.dart';
import 'recipe_full.dart';

class FavoriteRecipes extends StatefulWidget {
  const FavoriteRecipes({Key? key}) : super(key: key);

  @override
  State<FavoriteRecipes> createState() => _FavoriteRecipesState();
}

class _FavoriteRecipesState extends State<FavoriteRecipes> {
  final recipeViewModel = ViewModelProvider.get<RecipeViewModel>(recipeKey);
  late final StreamSubscription subscription;

  @override
  void initState() {
    super.initState();
    subscription = recipeViewModel.startUIListening((event) {
      switch (event) {
        case RecipeEvent.openRecipe:
          if (!mounted) return;
          final id = recipeViewModel.currentRecipeId;
          if (id == null) {
            throw Exception('Cannot open recipe full page. It was null');
          }
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => RecipeFull(key: Key('recipeFull$id'), id: id)),
          );
          break;
        case RecipeEvent.hideParams:
        case RecipeEvent.openAllParams:
        case RecipeEvent.openDigest:
          break;
      }
    });
    recipeViewModel.loadFavoriteRecipes();
  }

  @override
  void dispose() {
    recipeViewModel.removeUIListeners(subscription);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: recipeViewModel,
      child: Consumer<RecipeViewModel>(
        builder: (_, viewModel, ___) {
          if (viewModel.favoriteIds.isEmpty && !recipeViewModel.loading) {
            return noResult();
          }
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: LinearLoading(
                  Theme.of(context).primaryColor,
                  show: recipeViewModel.loading,
                ),
              ),
              Flexible(
                child: ListView.builder(
                  keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                  itemBuilder: (ctx, i) {
                    final element = viewModel.favoriteRecipes[i];
                    final id = element.id;
                    return RecipeCard(
                      key: Key('recipeCard$id'),
                      recipe: element,
                      onTap: viewModel.processingIds.contains(id) ? null : () => viewModel.onRecipeTap(id: id),
                      viewModel: viewModel,
                      pageType: PageType.favoritePage,
                    );
                  },
                  itemCount: viewModel.favoriteRecipes.length,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget noResult() {
    return Align(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(flex: 1),
          Icon(
            Icons.favorite,
            size: 220,
            color: Theme.of(context).primaryColor.withOpacity(0.1),
          ),
          const Text(
            "There is no favorite recipes",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
          const Spacer(flex: 2),
        ],
      ),
    );
  }
}
