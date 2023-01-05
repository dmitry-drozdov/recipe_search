import 'dart:convert';
import 'dart:io';

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

  void onRemove();
}

class RecipeRepositoryImpl extends RecipeRepository {
  late HttpClient client;

  RecipeRepositoryImpl() {
    client = HttpClient();
    client.idleTimeout = const Duration(seconds: 90);
    client.maxConnectionsPerHost = 10;
  }

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
}
