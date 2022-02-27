import 'package:json_annotation/json_annotation.dart';

part 'recipe_model.g.dart';

@JsonSerializable(createToJson: false)
class Recipe {
  final String uri;
  final String label;
  final String image;
  final String source;
  final String url;
  final String shareAs;
  final List<String> dietLabels;
  final List<String> healthLabels;
  final List<String> cautions;
  final List<String> ingredientLines;
  final int calories;
  final int glycemicIndex;
  final int totalCO2Emissions;
  final String co2EmissionsClass;
  final int totalWeight;
  final List<String> cuisineType;
  final List<String> mealType;
  final List<String> dishType;

  Recipe({
    required this.uri,
    required this.label,
    required this.image,
    required this.source,
    required this.url,
    required this.shareAs,
    required this.dietLabels,
    required this.healthLabels,
    required this.cautions,
    required this.ingredientLines,
    required this.calories,
    required this.glycemicIndex,
    required this.totalCO2Emissions,
    required this.co2EmissionsClass,
    required this.totalWeight,
    required this.cuisineType,
    required this.mealType,
    required this.dishType,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) => _$RecipeFromJson(json);
}
