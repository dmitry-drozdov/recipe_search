// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ingredient_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Ingredient _$IngredientFromJson(Map<String, dynamic> json) => Ingredient(
      text: json['text'] as String,
      quantity: (json['quantity'] as num).toDouble(),
      measure: json['measure'] as String?,
      food: json['food'] as String,
      weight: (json['weight'] as num).toDouble(),
      foodId: json['foodId'] as String,
    );

Map<String, dynamic> _$IngredientToJson(Ingredient instance) =>
    <String, dynamic>{
      'text': instance.text,
      'quantity': instance.quantity,
      'measure': instance.measure,
      'food': instance.food,
      'weight': instance.weight,
      'foodId': instance.foodId,
    };
