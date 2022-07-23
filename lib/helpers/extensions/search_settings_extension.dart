import 'package:recipe_search/models/search_settings.dart';

extension SearchSettingsExtension on SearchSettings {
  Map<String, dynamic> get marshal {
    return {
      'search': search,
      'dietLabels': dietLabels,
      'healthLabels': healthLabels,
      'calories': caloriesRange,
    };
  }
}
