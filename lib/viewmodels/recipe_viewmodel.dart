import 'dart:async';
import 'dart:developer';

import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:recipe_search/models/enums/diet_label.dart';
import 'package:recipe_search/models/enums/health_label.dart';
import 'package:recipe_search/models/recipe/recipe_model.dart';
import 'package:recipe_search/models/search_settings.dart';
import 'package:recipe_search/repositories/recipe_repo.dart';
import 'package:recipe_search/repositories/recipe_result.dart';
import 'package:recipe_search/utils/firestore.dart';
import 'package:sorted_list/sorted_list.dart';

import '../helpers/models/request_result_model.dart';
import '../main.dart';
import '../models/user_settings.dart';
import '../utils/internet_checker.dart';
import 'base_view_model.dart';

enum RecipeEvent {
  openRecipe,
  hideParams,
  openAllParams,
  openDigest,
}

abstract class RecipeViewModel extends BaseViewModel<Recipe, RecipeEvent> {
  RecipeViewModel() : super();

  factory RecipeViewModel.create(String userId) => RecipeViewModelImpl(userId);

  Future<void> loadRecipesFirstPage();

  Future<void> loadRecipesNextPage();

  Future<void> loadFavoriteRecipes();

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

  void onDigestTap();

  void addOrUpdateFavouriteRecipe({
    required String recipeId,
    required DateTime timestamp,
    required bool active,
  });

  bool isFavorite(String recipeId);

  Set<String> get favoriteIds;

  List<Recipe> get favoriteRecipes;

  void updateUserSettings({
    bool? askBeforeRemoving,
    SearchSettings? lastSearch,
  });

  bool get askBeforeRemoving;
}

class RecipeViewModelImpl extends RecipeViewModel {
  final checker = locator<InternetChecker>();
  final storage = locator<FirebaseStorage>();
  final recipeRepository = RecipeRepository.create();
  late final StreamSubscription<InternetConnectionStatus> listener;
  late String _userId;
  late UserSettings userSettings;

  RecipeViewModelImpl(String userId) : super() {
    _userId = userId;
    listener = checker.onStatusChange.listen((_) {
      updateRequire = true;
    });
    loadUserSettings();
    loadFavoriteIds();
  }

  @override
  void onRemove() {
    listener.cancel();
    recipeRepository.onRemove();
    super.onRemove();
  }

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
      await _processRequest(request, firstPage: true);
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

  Future<void> _processRequest(RequestResultModel request, {bool firstPage = false}) async {
    int? errorCode;
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
      errorCode = request.value as int;
      if (errorCode > 400) {
        await Future.delayed(const Duration(seconds: 10));
      }
    }
    storage.logSearch(
      searchSettings: searchSettings,
      firstPage: firstPage,
      timestamp: DateTime.now(),
      errorCode: errorCode,
    );
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
    updateUserSettings(lastSearch: searchSettings);
    notifyListeners();
  }

  @override
  void onAllParamsTap() {
    uiEventSubject.add(RecipeEvent.openAllParams);
  }

  @override
  void onDigestTap() {
    uiEventSubject.add(RecipeEvent.openDigest);
  }

  //----------------------------------------- favourite recipes  -----------------------------------------

  final FavouriteData _favoriteData = {};

  final _favoriteRecipes = SortedList<Recipe>((a, b) => b.likeTimeOrNow.compareTo(a.likeTimeOrNow));

  @override
  Set<String> get favoriteIds => _favoriteData.keys.toSet();

  @override
  List<Recipe> get favoriteRecipes => _favoriteRecipes;

  Future<void> loadFavoriteIds() async {
    final data = await storage.getFavouriteRecipes(userId: _userId);
    _favoriteData.addAll(data);
    notifyListeners();
  }

  Future<void> _processFavorite(String id) async {
    final res = await recipeRepository.getRecipeById(id);
    if (!res.result || res.value is! Recipe || _favoriteRecipes.contains(res.value)) {
      return;
    }
    final recipe = res.value as Recipe;
    recipe.likeTime = _favoriteData[recipe.id];
    _favoriteRecipes.add(recipe);
  }

  @override
  Future<void> loadFavoriteRecipes() async {
    setLoading(value: true);

    final alreadyFetched = _favoriteRecipes.map((e) => e.id).toSet();
    final diff = favoriteIds.difference(alreadyFetched);

    await Future.wait(diff.map((id) => _processFavorite(id)));

    setLoading(value: false);
  }

  @override
  void addOrUpdateFavouriteRecipe({
    required String recipeId,
    required DateTime timestamp,
    required bool active,
  }) {
    final recipe = active
        ? items.firstWhere((element) => element.id == recipeId)
        : _favoriteRecipes.firstWhere((element) => element.id == recipeId);
    storage.addOrUpdateFavouriteRecipe(
      userId: _userId,
      recipeId: recipe.id,
      timestamp: timestamp,
      active: active,
    );
    if (active) {
      _favoriteData[recipe.id] = timestamp;
      recipe.likeTime = timestamp;
      _favoriteRecipes.add(recipe);
      recipeRepository.cacheRecipe(recipe);
    } else {
      _favoriteData.remove(recipe.id);
      _favoriteRecipes.remove(recipe);
      recipeRepository.deleteRecipeCache(recipe);
    }
    notifyListeners();
  }

  @override
  bool isFavorite(String recipeId) => favoriteIds.contains(recipeId);

  //----------------------------------------- user settings -----------------------------------------

  @override
  bool get askBeforeRemoving => userSettings.askBeforeRemoving;

  Future<void> loadUserSettings() async {
    userSettings = await storage.getUserSettings(userId: _userId) ?? UserSettings.base();
    searchSettings = userSettings.lastSearch ?? SearchSettings.noSettings();
    loadRecipesFirstPage();
  }

  @override
  Future<void> updateUserSettings({
    bool? askBeforeRemoving,
    SearchSettings? lastSearch,
  }) async {
    userSettings = UserSettings.copyWith(
      userSettings,
      lastSearch: lastSearch,
      askBeforeRemoving: askBeforeRemoving,
    );
    storage.addOrUpdateUserSettings(
      userId: _userId,
      userSettings: userSettings,
    );
  }
}
