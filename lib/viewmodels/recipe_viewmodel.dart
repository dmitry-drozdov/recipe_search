import 'dart:developer';

import 'package:recipe_search/models/recipe_model.dart';
import 'package:recipe_search/repositories/recipe_repo.dart';

import 'base_view_model.dart';

abstract class RecipeViewModel extends BaseViewModel<Recipe, void> {
  RecipeViewModel() : super();

  factory RecipeViewModel.create() => RecipeViewModelImpl();

  Future<void> loadRecipes(String text);
}

class RecipeViewModelImpl extends RecipeViewModel {
  RecipeRepository recipeRepository = RecipeRepository.create();

  RecipeViewModelImpl() : super();

  @override
  Future<void> loadRecipes(String text) async {
    setLoading(value: true);
    try {
      final request = await recipeRepository.getRecipes(text: text);
      if (request.result) {
        silenceClearItems();
        silenceAddRange(request.value);
      }
    } on Exception catch (e) {
      log('Exception during getting recipes: $e');
    }
    setLoading(value: false);
  }
}
