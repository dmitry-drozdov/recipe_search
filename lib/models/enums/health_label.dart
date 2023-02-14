import 'package:recipe_search/helpers/extensions/string_capitalize.dart';
import 'package:recipe_search/models/enums/labels.dart';

enum HealthLabel {
  alcoholCocktail,
  alcoholFree,
  celeryFree,
  crustaceanFree,
  dairyFree,
  dash,
  eggFree,
  fishFree,
  fodmapFree,
  glutenFree,
  immunoSupportive,
  ketoFriendly,
  kidneyFriendly,
  kosher,
  // lowFatAbs,
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
    return name.replaceAllMapped(RegExp(r"[A-Z]"), (m) => ' ${m[0]}').trim().toLowerCase().capitalizeFirstAPI;
  }

  // HealthLabel.redMeatFree -> red-meat-free
  String get api {
    switch (this) {
      case HealthLabel.mediterranean:
        return 'Mediterranean';
      case HealthLabel.dash:
        return 'DASH';
      default:
        break;
    }
    return view.replaceAll(" ", "-").toLowerCase();
  }

  String get query {
    return 'health=$api';
  }
}

List<HealthLabel> healthLabelFromJson(List<dynamic> json) {
  return labelFromJson<HealthLabel>(json);
}

List<dynamic> healthLabelToJson(List<HealthLabel> labels) {
  return labelToJson<HealthLabel>(labels);
}
