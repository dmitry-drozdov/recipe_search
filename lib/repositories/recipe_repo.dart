import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:localstorage/localstorage.dart';
import 'package:mutex/mutex.dart';
import 'package:recipe_search/models/recipe/recipe_model.dart';
import 'package:recipe_search/repositories/recipe_result.dart';

import '../helpers/models/request_result_model.dart';
import '../secrets.dart';

abstract class RecipeRepository {
  RecipeRepository();

  factory RecipeRepository.create() {
    return RecipeRepositoryImpl();
  }

  Future<RequestResultModel> getRecipes({String? text, String? nextUrl, String params = ''});

  Future<RequestResultModel> getRecipeById(String recipeId);

  void cacheRecipe(Recipe recipe);

  void deleteRecipeCache(Recipe recipe);

  void onRemove();
}

class RecipeRepositoryImpl extends RecipeRepository {
  final client = HttpClient()
    ..idleTimeout = const Duration(seconds: 90)
    ..maxConnectionsPerHost = 10;

  final m = Mutex();
  final fileCacheManager = DefaultCacheManager();
  final storage = LocalStorage('recipe_repo');

  RecipeRepositoryImpl();

  @override
  void onRemove() {
    client.close();
  }

  @override
  Future<RequestResultModel> getRecipes({String? text, String? nextUrl, String params = ''}) async {
    assert(text != null || nextUrl != null);
    final query = nextUrl ??
        'https://api.edamam.com/api/recipes/v2?type=public&q=$text&app_id=$applicationId&app_key=$applicationKey&$params';

    final request = await client.getUrl(Uri.parse(query));
    final response = await request.close();
    final body = await response.transform(utf8.decoder).join();

    final recipes = <Recipe>[];
    final jsonData = jsonDecode(body);
    if (jsonData['hits'] == null || jsonData['hits'].length == 0 || jsonData['hits'][0] == null) {
      return RequestResultModel(result: false, value: response.statusCode);
    }
    jsonData['hits'].forEach((r) => recipes.add(Recipe.fromJson(r['recipe'])));
    final href = jsonData['_links'] == null || jsonData['_links'].isEmpty ? '' : jsonData['_links']['next']['href'];
    final result = RecipeResult(nextUrl: href, recipes: recipes, end: href.isEmpty);
    return RequestResultModel(result: true, value: result);
  }

  @override
  Future<RequestResultModel> getRecipeById(String recipeId) async {
    assert(recipeId != "");

    // if has connection get recipe by id and update cache
    if (await InternetConnectionChecker().hasConnection) {
      final result = await getRecipeByIdApi(recipeId);
      if (!result.result) {
        return result;
      }

      cacheRecipe(result.value);

      return result;
    }

    // otherwise try to get item from cache
    final json = await m.protect<Map<String, dynamic>?>(() async {
      return await storage.getItem(recipeId);
    });

    final found = json?.isNotEmpty == true;

    log('got recipes from cache: $recipeId $found');

    if (!found) {
      return RequestResultModel(result: false);
    }

    return RequestResultModel(result: true, value: Recipe.fromJson(json!));
  }

  Future<RequestResultModel> getRecipeByIdApi(String recipeId) async {
    final query =
        'https://api.edamam.com/api/recipes/v2/$recipeId?type=public&app_id=$applicationId&app_key=$applicationKey';

    final request = await client.getUrl(Uri.parse(query));
    final response = await request.close();
    final body = await response.transform(utf8.decoder).join();

    final jsonData = jsonDecode(body);
    if (jsonData['recipe'] == null) {
      return RequestResultModel(result: false, value: response.statusCode);
    }
    return RequestResultModel(result: true, value: Recipe.fromJson(jsonData['recipe']));
  }

  @override
  void cacheRecipe(Recipe recipe) {
    final recipeId = recipe.id;
    final url = recipe.betImgUrl;
    if (url != null) {
      fileCacheManager.getSingleFile(url);
    }
    m.protect(() async {
      log('cache recipe $recipeId');
      await storage.setItem(recipeId, recipe);
    });
  }

  @override
  void deleteRecipeCache(Recipe recipe) {
    final recipeId = recipe.id;
    final url = recipe.betImgUrl;
    if (url != null) {
      fileCacheManager.removeFile(url);
    }
    m.protect(() async {
      log('delete recipe cache $recipeId');
      await storage.deleteItem(recipeId);
    });
  }
}
