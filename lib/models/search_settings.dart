import 'package:equatable/equatable.dart';
import 'package:recipe_search/helpers/range.dart';
import 'package:recipe_search/helpers/update_dynamic.dart';
import 'package:recipe_search/models/enums/diet_label.dart';
import 'package:recipe_search/models/enums/health_label.dart';

const delimiter = '&';

class SearchSettings extends Equatable {
  final String search;
  final List<DietLabel> dietLabels;
  final List<HealthLabel> healthLabels;
  final Range caloriesRange;

  const SearchSettings({
    required this.search,
    required this.dietLabels,
    required this.healthLabels,
    required this.caloriesRange,
  });

  factory SearchSettings.copyWith(
    SearchSettings old, {
    String? search,
    List<DietLabel>? dietLabels,
    List<HealthLabel>? healthLabels,
    int? caloriesMin,
    int? caloriesMax,
  }) {
    return SearchSettings(
      search: update(old.search, search),
      dietLabels: update(old.dietLabels, dietLabels),
      healthLabels: update(old.healthLabels, healthLabels),
      caloriesRange: Range.copyWith(old.caloriesRange, min: caloriesMin, max: caloriesMax),
    );
  }

  factory SearchSettings.noSettings() {
    return SearchSettings(
      search: '',
      dietLabels: const <DietLabel>[],
      healthLabels: const <HealthLabel>[],
      caloriesRange: Range.defaultRange(),
    );
  }

  String get dietLabelsQuery => dietLabels.map((e) => e.query).join(delimiter);

  String get healthLabelsQuery => healthLabels.map((e) => e.query).join(delimiter);

  String get labelsQuery => [dietLabelsQuery, healthLabelsQuery].join(delimiter);

  bool get emptySearchText => search.isEmpty;

  @override
  List<Object?> get props => [search, ...dietLabels, ...healthLabels, caloriesRange];
}
