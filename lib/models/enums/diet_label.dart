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
        return "high_fiber";
      case DietLabel.highProtein:
        return "high_protein";
      case DietLabel.lowCarb:
        return "low_carb";
      case DietLabel.lowFat:
        return "low_fat";
      case DietLabel.lowSodium:
        return "low_sodium";
    }
  }

  String get query {
    return 'diet=$this';
  }
}
