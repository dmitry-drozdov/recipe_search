// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Recipe _$RecipeFromJson(Map<String, dynamic> json) => Recipe(
      uri: json['uri'] as String,
      label: json['label'] as String,
      image: json['image'] as String,
      images: Images.fromJson(json['images'] as Map<String, dynamic>),
      source: json['source'] as String,
      url: json['url'] as String,
      shareAs: json['shareAs'] as String,
      dietLabels: dietLabelFromJson(json['dietLabels'] as List),
      healthLabels: healthLabelFromJson(json['healthLabels'] as List),
      cautions:
          (json['cautions'] as List<dynamic>).map((e) => e as String).toList(),
      ingredientLines: (json['ingredientLines'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      ingredients: (json['ingredients'] as List<dynamic>)
          .map((e) => Ingredient.fromJson(e as Map<String, dynamic>))
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
      dishType: (json['dishType'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      digest: (json['digest'] as List<dynamic>)
          .map((e) => Digest.fromJson(e as Map<String, dynamic>))
          .toList(),
      yield: (json['yield'] as num).toDouble(),
      likeTime: json['likeTime'] == null
          ? null
          : DateTime.parse(json['likeTime'] as String),
    );

Map<String, dynamic> _$RecipeToJson(Recipe instance) => <String, dynamic>{
      'uri': instance.uri,
      'label': instance.label,
      'image': instance.image,
      'images': imagesToJson(instance.images),
      'source': instance.source,
      'url': instance.url,
      'shareAs': instance.shareAs,
      'dietLabels': dietLabelToJson(instance.dietLabels),
      'healthLabels': healthLabelToJson(instance.healthLabels),
      'cautions': instance.cautions,
      'ingredientLines': instance.ingredientLines,
      'ingredients': instance.ingredients.map((e) => e.toJson()).toList(),
      'calories': instance.calories,
      'glycemicIndex': instance.glycemicIndex,
      'totalCO2Emissions': instance.totalCO2Emissions,
      'co2EmissionsClass': instance.co2EmissionsClass,
      'totalWeight': instance.totalWeight,
      'cuisineType': instance.cuisineType,
      'mealType': instance.mealType,
      'dishType': instance.dishType,
      'digest': instance.digest.map((e) => e.toJson()).toList(),
      'yield': instance.yield,
      'likeTime': instance.likeTime?.toIso8601String(),
    };
