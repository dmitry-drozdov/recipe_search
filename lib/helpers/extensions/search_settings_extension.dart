import 'package:recipe_search/models/enums/diet_label.dart';
import 'package:recipe_search/models/enums/health_label.dart';
import 'package:recipe_search/models/search_settings.dart';

extension SearchSettingsExtension on SearchSettings {
  Map<String, dynamic> get marshal {
    return {
      'search': search,
      'dietLabels': dietLabels.map((e) => e.api).toList(),
      'healthLabels': healthLabels.map((e) => e.api).toList(),
      'calories': caloriesRange.toJson(),
    };
  }
}
