import 'dart:developer';

import 'package:recipe_search/models/recipe/recipe_model.dart';
import 'package:recipe_search/repositories/recipe_repo.dart';

import 'base_view_model.dart';

abstract class RecipeViewModel extends BaseViewModel<Recipe, void> {
  RecipeViewModel() : super();

  factory RecipeViewModel.create() => RecipeViewModelImpl();

  Future<void> loadRecipes({String text});
}

class RecipeViewModelImpl extends RecipeViewModel {
  RecipeRepository recipeRepository = RecipeRepository.create();

  RecipeViewModelImpl() : super();

  String? previousText;

  @override
  Future<void> loadRecipes({String? text}) async {
    setLoading(value: true);
    if (text != null && previousText != text) {
      silenceClearItems();
      previousText = text;
    }
    text ??= previousText;

    try {
      final request = await recipeRepository.getRecipes(text: text!, from: items.length + 1, to: items.length + 11);
      if (request.result) {
        silenceAddRange(request.value);
      }
    } on Exception catch (e) {
      log('Exception during getting recipes: $e');
    }
    setLoading(value: false);
  }
}
