import 'package:recipe_search/models/recipe/recipe_model.dart';

class RecipeResult {
  final String nextUrl;
  final List<Recipe> recipes;
  final bool end;

  RecipeResult({
    required this.nextUrl,
    required this.recipes,
    required this.end,
  });
}
