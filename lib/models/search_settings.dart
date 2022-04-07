import 'package:recipe_search/helpers/update_dynamic.dart';
import 'package:recipe_search/models/enums/diet_label.dart';
import 'package:recipe_search/models/enums/health_label.dart';
import 'package:equatable/equatable.dart';

class SearchSettings extends Equatable {
  final String search;
  final List<DietLabel> dietLabels;
  final List<HealthLabel> healthLabels;

  const SearchSettings({
    required this.search,
    required this.dietLabels,
    required this.healthLabels,
  });

  factory SearchSettings.copyWith(
    SearchSettings old, {
    String? search,
    List<DietLabel>? dietLabels,
    List<HealthLabel>? healthLabels,
  }) {
    return SearchSettings(
      search: update(old.search, search),
      dietLabels: update(old.dietLabels, dietLabels),
      healthLabels: update(old.healthLabels, healthLabels),
    );
  }

  @override
  List<Object?> get props => [search, ...dietLabels, ...healthLabels];
}
