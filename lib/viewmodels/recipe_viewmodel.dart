import 'dart:developer';

import 'package:recipe_search/models/recipe/recipe_model.dart';
import 'package:recipe_search/repositories/recipe_repo.dart';
import 'package:recipe_search/repositories/recipe_result.dart';

import 'base_view_model.dart';

enum RecipeEvent {
  openRecipe,
}

abstract class RecipeViewModel extends BaseViewModel<Recipe, RecipeEvent> {
  RecipeViewModel() : super();

  factory RecipeViewModel.create() => RecipeViewModelImpl();

  Future<void> loadRecipes({String? text});

  void onRecipeTap({required String id});

  String? get currentRecipeId;
}

class RecipeViewModelImpl extends RecipeViewModel {
  RecipeRepository recipeRepository = RecipeRepository.create();

  RecipeViewModelImpl() : super();

  // Search recipes by text

  String? previousText;
  String? nextUrl;

  @override
  Future<void> loadRecipes({String? text}) async {
    if (text?.isNotEmpty == true && text == previousText) {
      return;
    }
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

  // Open recipe full information

  String? _currentRecipeId;

  @override
  void onRecipeTap({required String id}) {
    processingIds.add(id);
    notifyListeners();

    _currentRecipeId = id;
    uiEventSubject.add(RecipeEvent.openRecipe);

    processingIds.remove(id);
    notifyListeners();
  }

  @override
  String? get currentRecipeId => _currentRecipeId;
}
