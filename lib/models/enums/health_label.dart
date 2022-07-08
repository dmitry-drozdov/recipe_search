import 'package:recipe_search/helpers/string_capitalize.dart';

enum HealthLabel {
  alcoholCocktail,
  alcoholFree,
  celeryFree,
  crustaceanFree,
  dairyFree,
  eggFree,
  fishFree,
  fodmapFree,
  glutenFree,
  immunoSupportive,
  ketoFriendly,
  kidneyFriendly,
  kosher,
  lowFatAbs,
  lowPotassium,
  lowSugar,
  lupineFree,
  mediterranean,
  molluskFree,
  mustardFree,
  noOilAdded,
  paleo,
  peanutFree,
  pescatarian,
  porkFree,
  redMeatFree,
  sesameFree,
  shellfishFree,
  soyFree,
  sugarConscious,
  sulfiteFree,
  treeNutFree,
  vegan,
  vegetarian,
  wheatFree,
}

extension HealthLabelExtension on HealthLabel {
  // HealthLabel.redMeatFree -> redMeatFree
  String get name {
    return toString().split(".").skip(1).join();
  }

  // HealthLabel.redMeatFree -> Red meat free
  String get view {
    return name.replaceAllMapped(RegExp(r"[A-Z]"), (m) => ' ${m[0]}').trim().toLowerCase().capitalizeFirst();
  }

  // HealthLabel.redMeatFree -> red-meat-free
  String get api {
    return view.replaceAll(" ", "-").toLowerCase();
  }

  String get query {
    return 'health=$api';
  }
}

HealthLabel healthLabelFromStr(String value) {
  final lower = value.toLowerCase();
  print(lower);
  return HealthLabel.values.firstWhere((element) => element.api == lower || element.view.toLowerCase() == lower);
}

List<HealthLabel> healthLabelFromJson(List<dynamic> json) {
  return json.map((e) => healthLabelFromStr(e)).toList();
}
