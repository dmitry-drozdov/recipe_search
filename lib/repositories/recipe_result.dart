import 'package:recipe_search/models/recipe/recipe_model.dart';

class RecipeResult {
  final String nextUrl;
  final List<Recipe> recipes;

  RecipeResult({
    required this.nextUrl,
    required this.recipes,
  });
}
