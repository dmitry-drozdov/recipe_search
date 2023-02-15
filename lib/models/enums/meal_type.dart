import 'labels.dart';

enum MealType {
  breakfast,
  brunch,
  lunchDinner,
  lunch,
  dinner,
  snack,
  teatime,
}

extension MealTypeExtension on MealType {
  String get view {
    switch (this) {
      case MealType.breakfast:
        return 'Breakfast';
      case MealType.brunch:
        return 'Brunch';
      case MealType.lunchDinner:
        return 'Lunch/Dinner';
      case MealType.snack:
        return 'Snack';
      case MealType.teatime:
        return 'Teatime';
      case MealType.lunch:
        return 'Lunch';
      case MealType.dinner:
        return 'Dinner';
    }
  }

  String get api {
    switch (this) {
      case MealType.breakfast:
        return 'breakfast';
      case MealType.brunch:
        return 'brunch';
      case MealType.lunchDinner:
        return 'lunch/dinner';
      case MealType.snack:
        return 'snack';
      case MealType.teatime:
        return 'teatime';
      case MealType.lunch:
        return 'lunch';
      case MealType.dinner:
        return 'dinner';
    }
  }

  String get query {
    return 'mealType=$api';
  }
}

List<MealType> mealTypeFromJson(List<dynamic> json) {
  return labelFromJson<MealType>(json);
}

List<dynamic> mealTypeToJson(List<MealType> labels) {
  return labelToJson<MealType>(labels);
}
