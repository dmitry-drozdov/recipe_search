import 'package:json_annotation/json_annotation.dart';

part 'ingredient_model.g.dart';

@JsonSerializable(createToJson: false)
class Ingredient {
  final String text;
  final double quantity;
  final String? measure;
  final String food;
  final double weight;
  final String foodId;

  Ingredient({
    required this.text,
    required this.quantity,
    this.measure,
    required this.food,
    required this.weight,
    required this.foodId,
  });

  factory Ingredient.fromJson(Map<String, dynamic> json) => _$IngredientFromJson(json);
}
