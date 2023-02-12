import 'package:recipe_search/models/enums/diet_label.dart';

import 'health_label.dart';

List<T> labelFromJson<T>(List<dynamic> json) {
  return json.map((e) => _labelFromStr<T>(e)).toList();
}

List<dynamic> labelToJson<T>(List<T> labels) {
  return labels.map((e) => _getApi<T>(e)).toList();
}

T _labelFromStr<T>(String value) {
  final lower = value.toLowerCase();
  List values = [];
  switch (T) {
    case HealthLabel:
      values = HealthLabel.values;
      break;
    case DietLabel:
      values = DietLabel.values;
      break;
  }
  return values.firstWhere((e) => _getApi<T>(e) == lower || _getView<T>(e).toLowerCase() == lower);
}

String _getApi<T>(T v) {
  switch (T) {
    case HealthLabel:
      return (v as HealthLabel).api;
    case DietLabel:
      return (v as DietLabel).api;
    default:
      return "";
  }
}

String _getView<T>(T v) {
  switch (T) {
    case HealthLabel:
      return (v as HealthLabel).view;
    case DietLabel:
      return (v as DietLabel).view;
    default:
      return "";
  }
}
