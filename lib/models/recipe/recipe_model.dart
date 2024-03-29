import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:recipe_search/helpers/extensions/string_capitalize.dart';
import 'package:recipe_search/helpers/images/images_model.dart';
import 'package:recipe_search/models/digest/digest_model.dart';
import 'package:recipe_search/models/enums/diet_label.dart';
import 'package:recipe_search/models/enums/health_label.dart';
import 'package:recipe_search/models/ingredient/ingredient_model.dart';

import '../enums/meal_type.dart';

part 'recipe_model.g.dart';

@JsonSerializable(explicitToJson: true, createToJson: true)
class Recipe extends Equatable {
  final String uri;
  final String label;
  final String image;
  @JsonKey(toJson: imagesToJson)
  final Images images;
  final String source;
  final String url;
  final String shareAs;
  @JsonKey(fromJson: dietLabelFromJson, toJson: dietLabelToJson)
  final List<DietLabel> dietLabels;
  @JsonKey(fromJson: healthLabelFromJson, toJson: healthLabelToJson)
  final List<HealthLabel> healthLabels;
  final List<String> cautions;
  final List<String> ingredientLines;
  final List<Ingredient> ingredients;
  final double calories;
  final int? glycemicIndex;
  final double totalWeight;
  final List<String> cuisineType;
  @JsonKey(fromJson: mealTypeFromJson, toJson: mealTypeToJson)
  final List<MealType> mealType;
  final List<String>? dishType;
  final List<Digest> digest;
  final double yield;
  DateTime? likeTime;

  DateTime get likeTimeOrNow => likeTime ?? DateTime.now();

  Recipe({
    required this.uri,
    required this.label,
    required this.image,
    required this.images,
    required this.source,
    required this.url,
    required this.shareAs,
    required this.dietLabels,
    required this.healthLabels,
    required this.cautions,
    required this.ingredientLines,
    required this.ingredients,
    required this.calories,
    this.glycemicIndex,
    required this.totalWeight,
    required this.cuisineType,
    required this.mealType,
    this.dishType,
    required this.digest,
    required this.yield,
    this.likeTime,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) => _$RecipeFromJson(json);

  Map<String, dynamic> toJson() => _$RecipeToJson(this);

  String get id {
    final index = uri.indexOf("_");
    if (index == -1) {
      throw Exception("Cannot get id. Incorrect uri provider: $uri");
    }
    return uri.substring(index);
  }

  int get servings => yield.round();

  // Getters for image

  Image? get thumbnailImg => images.thumbnail;

  Image? get smallImg => images.small;

  Image? get regularImg => images.regular;

  Image? get largeImg => images.large;

  Image? get bestImg => largeImg ?? regularImg ?? smallImg ?? thumbnailImg;

  String? get betImgUrl => bestImg?.url;

  // String getters for fields
  String get ingredientsStr => ingredients.map((e) => e.food.capitalizeFirst).join(', ');

  String get caloriesStr => _formatPerServ(calories);

  String get totalWeightStr => _formatPerServ(totalWeight);

  String get servingsStr => servings.toString();

  String get servingsDescription => Intl.plural(servings, one: 'Serving', other: 'Servings');

  @override
  List<Object?> get props => [id];

  String _formatPerServ(double val) {
    final iVal = val.round();
    final base = iVal.toString();
    if (servings <= 1) {
      return base;
    }
    final perServ = (iVal / servings).round().toString();
    return "$base ($perServ/serv)";
  }

  List<String> get ingredientLinesEx {
    final res = <String>[];

    for (final line in ingredientLines) {
      if (!line.contains(RegExp(r'[\d½¼⅓⅔¾]'))) {
        // does not contains measurement
        res.add(line);
        continue;
      }
      for (final ingredient in ingredients) {
        if (ingredient.text.toLowerCase() == line.toLowerCase()) {
          res.add('${line.capitalizeFirst} ${ingredient.weightStr}');
          break;
        }
      }
    }

    if (res.length != ingredientLines.length) {
      throw Exception("some data was not found\nRES: ${res.join("\n")}\nORIG: ${ingredientLines.join("\n")}");
    }

    return res;
  }
}
