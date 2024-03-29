import 'package:flutter/material.dart';
import 'package:recipe_search/helpers/app_colors.dart';
import 'package:recipe_search/helpers/extensions/widget_extension.dart';
import 'package:recipe_search/models/digest/digest_model.dart';
import 'package:recipe_search/models/recipe/recipe_model.dart';
import 'package:recipe_search/viewmodels/recipe_viewmodel.dart';
import 'package:recipe_search/viewmodels/viewmodel_provider.dart';

import 'helper/recipe_app_bar.dart';

const toggleTitle = Text(
  "Show per serving",
  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.indigo),
);

class RecipeDigest extends StatefulWidget {
  final String id;

  const RecipeDigest({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  State<RecipeDigest> createState() => _RecipeDigestState();
}

class _RecipeDigestState extends State<RecipeDigest> {
  final recipeViewModel = ViewModelProvider.get<RecipeViewModel>(recipeKey);
  late final Recipe recipe;
  late final List<Digest> digest;

  bool perServ = false;

  @override
  void initState() {
    super.initState();
    final items = recipeViewModel.items.toSet();
    items.addAll(recipeViewModel.favoriteRecipes);
    recipe = items.firstWhere((element) => element.id == widget.id);

    digest = recipe.digest;
    digest.sort((a, b) => b.subOrEmpty.length.compareTo(a.subOrEmpty.length));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            child: Scrollbar(
              child: CustomScrollView(
                slivers: <Widget>[
                  RecipeAppBar(image: recipe.bestImg, isFavorite: false),
                  SliverList(
                    delegate: SliverChildListDelegate(getContentWidgets()),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> getContentWidgets() {
    final result = <Widget>[
      Row(
        children: [
          Flexible(
            child: Text(
              "${recipe.label}\u{00A0}—\u{00A0}Digest",
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500, color: Colors.indigo),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ).padding8880,
          ),
        ],
      ),
      if (recipe.servings > 1)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                toggleTitle,
                Switch(
                  inactiveTrackColor: AppColors.lightBlueChip,
                  value: perServ,
                  onChanged: (val) {
                    if (mounted) setState(() => perServ = val);
                  },
                ),
              ],
            ),
            Text(
              "${recipe.servingsDescription}: ${recipe.servings}",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400, color: AppColors.indigoHint),
            ),
          ],
        ).paddingH8,
    ];

    final services = perServ ? recipe.servings : null;

    for (final d in digest) {
      result.add(d.row(services: services));
      for (final s in d.subOrEmpty) {
        result.add(s.row(services: services, indent: true));
      }
    }

    return result;
  }
}
