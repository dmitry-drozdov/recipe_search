import 'dart:convert';

import 'package:recipe_search/helpers/logger.dart';
import 'package:recipe_search/helpers/request_result_model.dart';
import 'package:http/http.dart' as http;
import 'package:recipe_search/models/recipe/recipe_model.dart';
import 'package:recipe_search/repositories/recipe_result.dart';
import '../secrets.dart';

abstract class RecipeRepository {
  RecipeRepository();

  factory RecipeRepository.create() {
    return RecipeRepositoryImpl();
  }

  Future<RequestResultModel> getRecipes({String? text, String? nextUrl});
}

class RecipeRepositoryImpl extends RecipeRepository {
  RecipeRepositoryImpl();

  @override
  Future<RequestResultModel> getRecipes({String? text, String? nextUrl}) async {
    assert(text != null || nextUrl != null);
    final query = nextUrl ??
        'https://api.edamam.com/api/recipes/v2?type=public&q=$text&app_id=$applicationId&app_key=$applicationKey';
    final response = await http.get(Uri.parse(query));
    logRequest(query, response);
    final recipes = <Recipe>[];
    final jsonData = jsonDecode(response.body);
    if (jsonData['hits'] == null || jsonData['hits'].length == 0 || jsonData['hits'][0] == null) {
      return RequestResultModel(result: false, value: response.statusCode);
    }
    jsonData['hits'].forEach((r) => recipes.add(Recipe.fromJson(r['recipe'])));
    final result = RecipeResult(nextUrl: jsonData['_links']['next']['href'], recipes: recipes);
    return RequestResultModel(result: true, value: result);
  }
}
