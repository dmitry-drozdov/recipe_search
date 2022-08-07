import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:recipe_search/helpers/logger.dart';
import 'package:recipe_search/helpers/request_result_model.dart';
import 'package:recipe_search/models/recipe/recipe_model.dart';
import 'package:recipe_search/repositories/recipe_result.dart';

import '../secrets.dart';

abstract class RecipeRepository {
  RecipeRepository();

  factory RecipeRepository.create() {
    return RecipeRepositoryImpl();
  }

  Future<RequestResultModel> getRecipes({String? text, String? nextUrl, String params = ''});

  Future<RequestResultModel> getRecipeById(String recipeId);
}

class RecipeRepositoryImpl extends RecipeRepository {
  RecipeRepositoryImpl();

  @override
  Future<RequestResultModel> getRecipes({String? text, String? nextUrl, String params = ''}) async {
    assert(text != null || nextUrl != null);
    final query = nextUrl ??
        'https://api.edamam.com/api/recipes/v2?type=public&q=$text&app_id=$applicationId&app_key=$applicationKey&$params';
    final response = await http.get(Uri.parse(query));
    logRequest(query, response);
    final recipes = <Recipe>[];
    final jsonData = jsonDecode(response.body);
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
    final response = await http.get(Uri.parse(query));
    logRequest(query, response);
    final jsonData = jsonDecode(response.body);
    print(jsonData);
    if (jsonData['recipe'] == null) {
      return RequestResultModel(result: false, value: response.statusCode);
    }
    return RequestResultModel(result: true, value: Recipe.fromJson(jsonData['recipe']));
  }
}
