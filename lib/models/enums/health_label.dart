import 'package:recipe_search/helpers/string_capitalize.dart';

enum HealthLabel {
  alcoholCocktail,
  alcoholFree,
  celeryFree,
  crustaceanFree,
  dairyFree,
  fishFree,
  fodMapFree,
  glutenFree,
  immunoSupportive,
  ketoFriendly,
  kidneyFriendly,
  kosher,
  lowFatAbs,
  lowPotassium,
  lowSugar,
  lupineFree,
  molluskFree,
  mustardFree,
  noOilAdded,
  peanutFree,
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
  String get view {
    return toString().split(RegExp(r"[A-Z]")).join(" ").toLowerCase().capitalize();
  }

  String get api {
    return toString().split(RegExp(r"[A-Z]")).join("-").toLowerCase();
  }

  String get query {
    return 'health=$api';
  }
}
