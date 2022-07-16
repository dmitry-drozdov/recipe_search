import 'dart:developer';

import 'package:recipe_search/helpers/request_result_model.dart';
import 'package:recipe_search/models/enums/diet_label.dart';
import 'package:recipe_search/models/enums/health_label.dart';
import 'package:recipe_search/models/recipe/recipe_model.dart';
import 'package:recipe_search/models/search_settings.dart';
import 'package:recipe_search/repositories/recipe_repo.dart';
import 'package:recipe_search/repositories/recipe_result.dart';

import 'base_view_model.dart';

enum RecipeEvent {
  openRecipe,
  hideParams,
  openAllParams,
}

abstract class RecipeViewModel extends BaseViewModel<Recipe, RecipeEvent> {
  RecipeViewModel() : super();

  factory RecipeViewModel.create() => RecipeViewModelImpl();

  Future<void> loadRecipesFirstPage();

  Future<void> loadRecipesNextPage();

  void onRecipeTap({required String id});

  String? get currentRecipeId;

  SearchSettings get searchSettings;

  bool get searchSettingsUpdated;

  void updateSearchSettings({
    String? newSearch,
    List<DietLabel>? newDietLabels,
    List<HealthLabel>? newHealthLabels,
    int? caloriesMin,
    int? caloriesMax,
  });

  void onAllParamsTap();
}

class RecipeViewModelImpl extends RecipeViewModel {
  RecipeRepository recipeRepository = RecipeRepository.create();

  RecipeViewModelImpl() : super();

  //----------------------------------------- Search requests -----------------------------------------

  var updateRequire = true;

  String? nextUrl;
  bool end = false;

  @override
  Future<void> loadRecipesFirstPage() async {
    setLoading(value: true);

    if (!updateRequire) {
      _exitWithFakeLoading();
      return;
    }

    nextUrl = null;
    end = false;
    updateRequire = false;

    backUpSearchSettings = searchSettings;
    notifyListeners();

    if (searchSettings.emptySearchText) {
      await _exitWithFakeLoading();
      silenceClearItems();
      return;
    }

    try {
      final request = await recipeRepository.getRecipes(
        text: searchSettings.search,
        params: searchSettings.query,
      );
      silenceClearItems();
      await _processRequest(request);
      if (items.isNotEmpty) {
        uiEventSubject.add(RecipeEvent.hideParams);
      }
    } on Exception catch (e) {
      log('loadRecipes| Exception during getting recipes: $e');
    }

    setLoading(value: false);
  }

  Future<void> _exitWithFakeLoading() async {
    await Future.delayed(const Duration(seconds: 1));
    setLoading(value: false);
  }

  @override
  Future<void> loadRecipesNextPage() async {
    if (end) {
      return;
    }

    setLoading(value: true);

    try {
      final request = await recipeRepository.getRecipes(
        text: searchSettings.search,
        nextUrl: nextUrl,
        params: searchSettings.query,
      );
      await _processRequest(request);
    } on Exception catch (e) {
      log('loadRecipes| Exception during getting recipes: $e');
    }

    setLoading(value: false);
  }

  Future<void> _processRequest(RequestResultModel request) async {
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
  }

  //----------------------------------------- Open recipe full information -----------------------------------------

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

  //----------------------------------------- search settings -----------------------------------------
  @override
  var searchSettings = SearchSettings.noSettings();

  // search settings with previous applied search
  var backUpSearchSettings = SearchSettings.noSettings();

  bool get firstLaunch => searchSettings == SearchSettings.noSettings() && searchSettings == backUpSearchSettings;

  @override
  bool get searchSettingsUpdated => searchSettings != backUpSearchSettings || firstLaunch;

  @override
  void updateSearchSettings({
    String? newSearch,
    List<DietLabel>? newDietLabels,
    List<HealthLabel>? newHealthLabels,
    int? caloriesMin,
    int? caloriesMax,
  }) {
    final newSearchSettings = SearchSettings.copyWith(
      searchSettings,
      search: newSearch,
      dietLabels: newDietLabels,
      healthLabels: newHealthLabels,
      caloriesMin: caloriesMin,
      caloriesMax: caloriesMax,
    );
    updateRequire = newSearchSettings != searchSettings;
    if (!updateRequire) {
      return;
    }
    searchSettings = newSearchSettings;
    notifyListeners();
  }

  @override
  void onAllParamsTap() {
    uiEventSubject.add(RecipeEvent.openAllParams);
  }
}
