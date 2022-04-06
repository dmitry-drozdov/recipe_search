import 'dart:developer';

import 'package:recipe_search/models/enums/diet_label.dart';
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

  List<DietLabel> get dietLabels;

  set dietLabels(List<DietLabel> value);
}

class RecipeViewModelImpl extends RecipeViewModel {
  RecipeRepository recipeRepository = RecipeRepository.create();

  RecipeViewModelImpl() : super();

  // Search recipes by text

  String? previousText;
  String? nextUrl;
  bool end = false;

  @override
  Future<void> loadRecipes({String? text}) async {
    if (text?.isNotEmpty == true && text == previousText) {
      return;
    }

    final newSearch = text != null && previousText != text;
    if (newSearch) {
      previousText = text;
      nextUrl = null;
      end = false;
    }
    if (end) {
      return;
    }
    text ??= previousText;

    setLoading(value: true);
    try {
      final request = await recipeRepository.getRecipes(
        text: text,
        nextUrl: nextUrl,
        params: dietQuery(),
      );
      if (newSearch) silenceClearItems();
      if (request.result) {
        final value = request.value;
        if (value is RecipeResult) {
          silenceAddRange(value.recipes);
          nextUrl = value.nextUrl;
          end = value.end;
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

  // Labels
  List<DietLabel> _dietLabels = DietLabel.values;

  @override
  List<DietLabel> get dietLabels {
    return _dietLabels;
  }

  @override
  set dietLabels(List<DietLabel> value) {
    _dietLabels = value;
    notifyListeners();
  }

  // TODO: implement class with search params that contains diet label and other labels
  String dietQuery() => _dietLabels.map((e) => e.query).join("&");
}
