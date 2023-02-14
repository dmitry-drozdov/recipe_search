import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:recipe_search/helpers/app_colors.dart';
import 'package:recipe_search/helpers/consts.dart';
import 'package:recipe_search/helpers/extensions/list_extension.dart';
import 'package:recipe_search/helpers/extensions/widget_extension.dart';
import 'package:recipe_search/models/recipe/recipe_model.dart';
import 'package:recipe_search/view/recipe/helper/labels_widget.dart';
import 'package:recipe_search/view/recipe/like_button.dart';
import 'package:recipe_search/view/recipe/recipe_digest.dart';
import 'package:recipe_search/viewmodels/recipe_viewmodel.dart';
import 'package:recipe_search/viewmodels/viewmodel_provider.dart';

import '../search/params.dart';
import 'helper/circle_info_widget.dart';
import 'helper/link_value_widget.dart';
import 'helper/recipe_app_bar.dart';
import 'helper/title_value_widget.dart';
import 'helper/title_widget.dart';
import 'helper/value_widget.dart';

class RecipeFull extends StatefulWidget {
  final String id;

  const RecipeFull({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  State<RecipeFull> createState() => _RecipeFullState();
}

class _RecipeFullState extends State<RecipeFull> {
  final recipeViewModel = ViewModelProvider.get<RecipeViewModel>(recipeKey);
  late final Recipe recipe;
  late final StreamSubscription subscription;

  @override
  void initState() {
    super.initState();
    final items = recipeViewModel.items.toSet();
    items.addAll(recipeViewModel.favoriteRecipes);
    recipe = items.firstWhere((element) => element.id == widget.id);

    subscription = recipeViewModel.startUIListening((event) {
      switch (event) {
        case RecipeEvent.openDigest:
          if (!mounted) {
            return;
          }
          final id = recipeViewModel.currentRecipeId;
          if (id == null) {
            throw Exception('Cannot open recipe digest page. It was null');
          }
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => RecipeDigest(key: Key('recipeDigest$id'), id: id)),
          );
          break;
        case RecipeEvent.openAllParams:
        case RecipeEvent.openRecipe:
        case RecipeEvent.userLoaded:
          break;
      }
    });
  }

  @override
  void dispose() {
    recipeViewModel.removeUIListeners(subscription);
    super.dispose();
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
                  RecipeAppBar(
                    image: recipe.bestImg,
                    isFavorite: recipeViewModel.isFavorite(recipe.id),
                  ),
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
    final theme = Theme.of(context);
    final blueColor = theme.primaryColor.withOpacity(0.1);
    String? weightPerServ, calPerServ;
    if (recipe.servings > 1) {
      weightPerServ = "${(recipe.totalWeight.round() / recipe.servings).toStringAsFixed(0)}/serv";
      calPerServ = "${(recipe.calories.round() / recipe.servings).toStringAsFixed(0)}/serv";
    }
    return [
      Row(
        children: [
          Container(
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
            child: Text(
              recipe.label,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500, color: Colors.indigo),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ).padding8888,
          ),
          LikeButton(
            viewModel: recipeViewModel,
            recipeId: widget.id,
            removingConfirmation: false,
          ),
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          CircleInfo(
            title: Intl.plural(recipe.ingredients.length, one: 'Ingr', other: 'Ingrs'),
            value: recipe.ingredients.length.toString(),
            borderColor: theme.primaryColor,
          ),
          CircleInfo(
            title: 'Kcal',
            value: recipe.calories.toStringAsFixed(0),
            subValue: calPerServ,
            borderColor: theme.primaryColor,
          ),
          CircleInfo(
            title: 'Grams',
            value: recipe.totalWeight.toStringAsFixed(0),
            subValue: weightPerServ,
            borderColor: theme.primaryColor,
          ),
          CircleInfo(
            title: recipe.servingsDescription,
            value: recipe.servingsStr,
            borderColor: theme.primaryColor,
          ),
        ],
      ).paddingB8,
      //-----------------------------------------------
      if (recipe.cautions.isNotEmpty) ...[
        TitleWidget(title: 'Cautions', color: AppColors.redBackground),
        Value(value: recipe.cautions.view, color: AppColors.redLetter, fontWeight: FontWeight.w500),
      ],
      //-----------------------------------------------
      if (recipe.ingredients.isNotEmpty) ...[
        const TitleWidget(title: 'Ingredients', fontWeight: FontWeight.w600),
        Value(
          value: recipe.ingredients.map((e) => e.food).join(', '),
          fontSize: 20,
        ),
      ],
      //-----------------------------------------------
      const TitleWidget(title: 'Ingredients details', fontWeight: FontWeight.w600),
      Value(value: listMarker + recipe.ingredientLinesEx.join('\n$listMarker'), fontSize: 20),
      //-----------------------------------------------
      if (recipe.cuisineType.isNotEmpty) ...[
        const TitleWidget(title: 'Cuisine type'),
        Value(value: recipe.cuisineType.view),
      ],
      //-----------------------------------------------
      if (recipe.dietLabels.isNotEmpty) ...[
        const TitleWidget(title: 'Diet labels'),
        Value(value: recipe.dietLabels.view),
      ],
      //-----------------------------------------------
      if (recipe.dishType?.isNotEmpty == true) ...[
        const TitleWidget(title: 'Dish type'),
        Value(value: recipe.dishType!.view),
      ],
      //-----------------------------------------------
      if (recipe.mealType.isNotEmpty) ...[
        const TitleWidget(title: 'Meal type'),
        Value(value: recipe.mealType.view),
      ],
      //-----------------------------------------------
      if (recipe.healthLabels.isNotEmpty) ...[
        const TitleWidget(title: 'Health labels'),
        Labels(
          values: recipe.healthLabels.view,
          selectedValues: recipeViewModel.searchSettings.healthLabels.view,
        ),
      ],
      //-----------------------------------------------
      if (recipe.glycemicIndex != null)
        TitleValue(title: 'Glycemic index', value: recipe.glycemicIndex.toString(), color: blueColor),
      //-----------------------------------------------
      if (recipe.totalCO2Emissions != null)
        TitleValue(
          title: 'Total CO2 Emissions',
          value: recipe.totalCO2Emissions.toString(),
          color: blueColor,
        ),
      //-----------------------------------------------
      if (recipe.co2EmissionsClass != null)
        TitleValue(title: 'CO2 Emissions Class', value: recipe.co2EmissionsClass!, color: blueColor),
      //-----------------------------------------------
      const TitleWidget(title: 'Link'),
      LinkValue(value: recipe.url, color: theme.primaryColor),
      //-----------------------------------------------
      const TitleWidget(title: 'Digest'),
      TextButton(
        onPressed: recipeViewModel.onDigestTap,
        style: buttonStyleLarge,
        child: const Text('View fats, carbs, vitamins and minerals', style: TextStyle(fontSize: 18)),
      ),
      //-----------------------------------------------
      const SizedBox(height: 2),
    ];
  }
}
