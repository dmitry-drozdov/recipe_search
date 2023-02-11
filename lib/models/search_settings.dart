import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:recipe_search/helpers/models/range.dart';
import 'package:recipe_search/helpers/update_dynamic.dart';
import 'package:recipe_search/models/enums/diet_label.dart';
import 'package:recipe_search/models/enums/health_label.dart';

part 'search_settings.g.dart';

const delimiter = '&';

@JsonSerializable(explicitToJson: true, createToJson: true)
class SearchSettings extends Equatable {
  final String search;
  final List<DietLabel> dietLabels;
  final List<HealthLabel> healthLabels;
  final Range caloriesRange;
  final Range ingredientsRange;

  const SearchSettings({
    required this.search,
    required this.dietLabels,
    required this.healthLabels,
    required this.caloriesRange,
    required this.ingredientsRange,
  });

  factory SearchSettings.fromJson(Map<String, dynamic> json) => _$SearchSettingsFromJson(json);

  Map<String, dynamic> toJson() => _$SearchSettingsToJson(this);

  factory SearchSettings.copyWith(
    SearchSettings old, {
    String? search,
    List<DietLabel>? dietLabels,
    List<HealthLabel>? healthLabels,
    int? caloriesMin,
    int? caloriesMax,
    int? ingredientsMin,
    int? ingredientsMax,
  }) {
    return SearchSettings(
      search: update(old.search, search),
      dietLabels: update(old.dietLabels, dietLabels),
      healthLabels: update(old.healthLabels, healthLabels),
      caloriesRange: Range.copyWith(old.caloriesRange, min: caloriesMin, max: caloriesMax),
      ingredientsRange: Range.copyWith(old.ingredientsRange, min: ingredientsMin, max: ingredientsMax),
    );
  }

  factory SearchSettings.noSettings() {
    return SearchSettings(
      search: '',
      dietLabels: const <DietLabel>[],
      healthLabels: const <HealthLabel>[],
      caloriesRange: Range.defaultCaloriesRange(),
      ingredientsRange: Range.defaultIngredientsRange(),
    );
  }

  String get dietLabelsQuery => dietLabels.map((e) => e.query).join(delimiter);

  String get healthLabelsQuery => healthLabels.map((e) => e.query).join(delimiter);

  String get query => [
        dietLabelsQuery,
        healthLabelsQuery,
        caloriesRange.caloriesQuery,
        ingredientsRange.ingredientsQuery,
      ].join(delimiter);

  bool get emptySearchText => search.isEmpty;

  @override
  List<Object?> get props => [search, ...dietLabels, ...healthLabels, caloriesRange, ingredientsRange];
}
