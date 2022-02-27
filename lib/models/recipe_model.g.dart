// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Recipe _$RecipeFromJson(Map<String, dynamic> json) => Recipe(
      uri: json['uri'] as String,
      label: json['label'] as String,
      image: json['image'] as String,
      source: json['source'] as String,
      url: json['url'] as String,
      shareAs: json['shareAs'] as String,
      dietLabels: (json['dietLabels'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      healthLabels: (json['healthLabels'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      cautions:
          (json['cautions'] as List<dynamic>).map((e) => e as String).toList(),
      ingredientLines: (json['ingredientLines'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      calories: (json['calories'] as num).toDouble(),
      glycemicIndex: json['glycemicIndex'] as int?,
      totalCO2Emissions: json['totalCO2Emissions'] as int?,
      co2EmissionsClass: json['co2EmissionsClass'] as String?,
      totalWeight: (json['totalWeight'] as num).toDouble(),
      cuisineType: (json['cuisineType'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      mealType:
          (json['mealType'] as List<dynamic>).map((e) => e as String).toList(),
      dishType:
          (json['dishType'] as List<dynamic>).map((e) => e as String).toList(),
    );
