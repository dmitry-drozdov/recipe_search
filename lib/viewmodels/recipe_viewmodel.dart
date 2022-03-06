import 'dart:developer';

import 'package:recipe_search/models/recipe/recipe_model.dart';
import 'package:recipe_search/repositories/recipe_repo.dart';
import 'package:recipe_search/repositories/recipe_result.dart';

import 'base_view_model.dart';

abstract class RecipeViewModel extends BaseViewModel<Recipe, void> {
  RecipeViewModel() : super();

  factory RecipeViewModel.create() => RecipeViewModelImpl();

  Future<void> loadRecipes({String? text});
}

class RecipeViewModelImpl extends RecipeViewModel {
  RecipeRepository recipeRepository = RecipeRepository.create();

  RecipeViewModelImpl() : super();

  String? previousText;
  String? nextUrl;

  @override
  Future<void> loadRecipes({String? text}) async {
    setLoading(value: true);
    if (text != null && previousText != text) {
      silenceClearItems();
      previousText = text;
      nextUrl = null;
    }
    text ??= previousText;

    try {
      final request = await recipeRepository.getRecipes(text: text, nextUrl: nextUrl);
      if (request.result) {
        final value = request.value;
        if (value is RecipeResult) {
          silenceAddRange(value.recipes);
          nextUrl = value.nextUrl;
        } else {
          log('loadRecipes| Incorrect type of value: ${value.runtimeType}');
        }
      } else {
        if (request.value as int > 400) {
          await Future.delayed(const Duration(seconds: 10));
        }
      }
    } on Exception catch (e) {
      log('loadRecipes| Exception during getting recipes: $e');
    }
    setLoading(value: false);
  }
}
