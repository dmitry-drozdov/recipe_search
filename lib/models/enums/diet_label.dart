import 'package:recipe_search/models/enums/labels.dart';

enum DietLabel {
  balanced,
  highFiber,
  highProtein,
  lowCarb,
  lowFat,
  lowSodium,
}

extension DietLabelExtension on DietLabel {
  String get view {
    switch (this) {
      case DietLabel.balanced:
        return "Balanced";
      case DietLabel.highFiber:
        return "High fiber";
      case DietLabel.highProtein:
        return "High protein";
      case DietLabel.lowCarb:
        return "Low carb";
      case DietLabel.lowFat:
        return "Low fat";
      case DietLabel.lowSodium:
        return "Low sodium";
    }
  }

  String get api {
    switch (this) {
      case DietLabel.balanced:
        return "balanced";
      case DietLabel.highFiber:
        return "high-fiber";
      case DietLabel.highProtein:
        return "high-protein";
      case DietLabel.lowCarb:
        return "low-carb";
      case DietLabel.lowFat:
        return "low-fat";
      case DietLabel.lowSodium:
        return "low-sodium";
    }
  }

  String get query {
    return 'diet=$api';
  }
}

List<DietLabel> dietLabelFromJson(List<dynamic> json) {
  return labelFromJson<DietLabel>(json);
}

List<dynamic> dietLabelToJson(List<DietLabel> labels) {
  return labelToJson<DietLabel>(labels);
}
