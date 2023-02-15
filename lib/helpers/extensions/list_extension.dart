import 'package:recipe_search/helpers/extensions/string_capitalize.dart';
import 'package:recipe_search/models/enums/diet_label.dart';
import 'package:recipe_search/models/enums/health_label.dart';
import 'package:recipe_search/models/enums/meal_type.dart';

extension ListExtension on List<String> {
  String get view => map((e) => e.capitalizeFirst).join(", ");
}

extension DietLabelListExtension on List<DietLabel> {
  String get view => map((e) => e.view.capitalizeFirst).join(", ");
}

extension HealthLabelListExtension on List<HealthLabel> {
  List<String> get view => map((e) => e.view.capitalizeFirst).toList();
}

extension MealTypeListExtension on List<MealType> {
  String get view => map((e) => e.view.capitalizeFirst).join(", ");
}
