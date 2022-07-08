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

DietLabel dietLabelFromStr(String value) {
  final lower = value.toLowerCase();
  return DietLabel.values.firstWhere((element) => element.api == lower || element.view.toLowerCase() == lower);
}

List<DietLabel> dietLabelFromJson(List<dynamic> json) {
  return json.map((e) => dietLabelFromStr(e)).toList();
}
