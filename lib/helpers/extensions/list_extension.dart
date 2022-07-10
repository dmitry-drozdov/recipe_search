import 'package:recipe_search/models/enums/diet_label.dart';
import 'package:recipe_search/models/enums/health_label.dart';

extension ListExtension on List<String> {
  String get view => join(", ");
}

extension DietLabelListExtension on List<DietLabel> {
  String get view => map((e) => e.view).join(", ");
}

extension HealthLabelListExtension on List<HealthLabel> {
  String get view => map((e) => e.view).join(", ");
}