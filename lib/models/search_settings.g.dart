// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchSettings _$SearchSettingsFromJson(Map<String, dynamic> json) =>
    SearchSettings(
      search: json['search'] as String,
      dietLabels: (json['dietLabels'] as List<dynamic>)
          .map((e) => $enumDecode(_$DietLabelEnumMap, e))
          .toList(),
      healthLabels: (json['healthLabels'] as List<dynamic>)
          .map((e) => $enumDecode(_$HealthLabelEnumMap, e))
          .toList(),
      caloriesRange:
          Range.fromJson(json['caloriesRange'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SearchSettingsToJson(SearchSettings instance) =>
    <String, dynamic>{
      'search': instance.search,
      'dietLabels':
          instance.dietLabels.map((e) => _$DietLabelEnumMap[e]!).toList(),
      'healthLabels':
          instance.healthLabels.map((e) => _$HealthLabelEnumMap[e]!).toList(),
      'caloriesRange': instance.caloriesRange.toJson(),
    };

const _$DietLabelEnumMap = {
  DietLabel.balanced: 'balanced',
  DietLabel.highFiber: 'highFiber',
  DietLabel.highProtein: 'highProtein',
  DietLabel.lowCarb: 'lowCarb',
  DietLabel.lowFat: 'lowFat',
  DietLabel.lowSodium: 'lowSodium',
};

const _$HealthLabelEnumMap = {
  HealthLabel.alcoholCocktail: 'alcoholCocktail',
  HealthLabel.alcoholFree: 'alcoholFree',
  HealthLabel.celeryFree: 'celeryFree',
  HealthLabel.crustaceanFree: 'crustaceanFree',
  HealthLabel.dairyFree: 'dairyFree',
  HealthLabel.dash: 'dash',
  HealthLabel.eggFree: 'eggFree',
  HealthLabel.fishFree: 'fishFree',
  HealthLabel.fodmapFree: 'fodmapFree',
  HealthLabel.glutenFree: 'glutenFree',
  HealthLabel.immunoSupportive: 'immunoSupportive',
  HealthLabel.ketoFriendly: 'ketoFriendly',
  HealthLabel.kidneyFriendly: 'kidneyFriendly',
  HealthLabel.kosher: 'kosher',
  HealthLabel.lowFatAbs: 'lowFatAbs',
  HealthLabel.lowPotassium: 'lowPotassium',
  HealthLabel.lowSugar: 'lowSugar',
  HealthLabel.lupineFree: 'lupineFree',
  HealthLabel.mediterranean: 'mediterranean',
  HealthLabel.molluskFree: 'molluskFree',
  HealthLabel.mustardFree: 'mustardFree',
  HealthLabel.noOilAdded: 'noOilAdded',
  HealthLabel.paleo: 'paleo',
  HealthLabel.peanutFree: 'peanutFree',
  HealthLabel.pescatarian: 'pescatarian',
  HealthLabel.porkFree: 'porkFree',
  HealthLabel.redMeatFree: 'redMeatFree',
  HealthLabel.sesameFree: 'sesameFree',
  HealthLabel.shellfishFree: 'shellfishFree',
  HealthLabel.soyFree: 'soyFree',
  HealthLabel.sugarConscious: 'sugarConscious',
  HealthLabel.sulfiteFree: 'sulfiteFree',
  HealthLabel.treeNutFree: 'treeNutFree',
  HealthLabel.vegan: 'vegan',
  HealthLabel.vegetarian: 'vegetarian',
  HealthLabel.wheatFree: 'wheatFree',
};
