import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart' ;
import 'package:recipe_search/helpers/consts.dart';
import 'package:recipe_search/helpers/list_extension.dart';
import 'package:recipe_search/models/recipe/recipe_model.dart';
import 'package:recipe_search/viewmodels/recipe_viewmodel.dart';
import 'package:recipe_search/viewmodels/viewmodel_provider.dart';

import 'helper/circle_info_widget.dart';
import 'helper/link_value_widget.dart';
import 'helper/title_value_widget.dart';
import 'helper/value_widget.dart';
import 'helper/title_widget.dart';

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

  @override
  void initState() {
    super.initState();
    recipe = recipeViewModel.items.firstWhere((element) => element.id == widget.id);
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
                  SliverAppBar(
                    leadingWidth: 40,
                    leading: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: RawMaterialButton(
                        onPressed: () => Navigator.of(context).pop(),
                        elevation: 2.0,
                        fillColor: Colors.indigo.withOpacity(0.3),
                        child: const Icon(Icons.arrow_back_rounded, size: 35.0),
                        shape: const CircleBorder(),
                      ),
                    ),
                    backgroundColor: Colors.white,
                    pinned: true,
                    stretch: true,
                    expandedHeight: 260,
                    flexibleSpace: CachedNetworkImage(
                      imageUrl: recipe.bestImg!.url,
                      placeholder: (_, __) => placeholderLarge,
                      fit: BoxFit.cover,
                    ),
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
    return [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          recipe.label,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500, color: Colors.indigo),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            CircleInfo(
              title: 'Weight',
              value: recipe.totalWeight.toStringAsFixed(0),
              borderColor: theme.primaryColor,
            ),
            CircleInfo(
              title: 'Calories',
              value: recipe.calories.toStringAsFixed(0),
              borderColor: theme.primaryColor,
            ),
          ],
        ),
      ),
      //-----------------------------------------------
      if (recipe.ingredients.isNotEmpty) ...[
        const TitleWidget(title: 'Ingredients', fontWeight: FontWeight.w600),
        Value(
          value: recipe.ingredients.map((e) => e.food).join(', '),
          fontSize: 20,
        ),
      ],
      //-----------------------------------------------
      if (recipe.cautions.isNotEmpty) ...[
        TitleWidget(title: 'Cautions', color: Colors.red.withOpacity(0.1)),
        Value(value: recipe.cautions.view),
      ],
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
        Value(value: recipe.healthLabels.view),
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
      const TitleWidget(title: 'Ingredients details', fontWeight: FontWeight.w600),
      Value(value: listMarker + recipe.ingredientLines.join('\n$listMarker'), fontSize: 20),
      //-----------------------------------------------
      const TitleWidget(title: 'Link'),
      LinkValue(value: recipe.shareAs, color: theme.primaryColor),
    ];
  }
}
