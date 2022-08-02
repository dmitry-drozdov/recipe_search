import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:recipe_search/helpers/consts.dart';
import 'package:recipe_search/helpers/extensions/edge_extension.dart';
import 'package:recipe_search/models/recipe/recipe_model.dart';
import 'package:recipe_search/view/recipe/like_button.dart';

import '../../viewmodels/recipe_viewmodel.dart';
import '../common.dart';

class RecipeCard extends StatelessWidget {
  final Recipe recipe;
  final void Function()? onTap;
  final RecipeViewModel viewModel;

  const RecipeCard({
    Key? key,
    required this.recipe,
    required this.onTap,
    required this.viewModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Stack(
        children: [
          content(),
          Positioned(
            right: 1,
            top: 1,
            child: LikeButton(
              viewModel: viewModel,
              recipeId: recipe.id,
            ),
          ),
        ],
      ),
    );
  }

  Widget content() {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(5),
        constraints: const BoxConstraints(maxHeight: 125),
        child: Row(
          children: [
            CachedNetworkImage(
              imageUrl: recipe.image,
              fit: BoxFit.contain,
              placeholder: (_, __) => placeholder,
              width: 90,
            ),
            Container(
              width: 270,
              padding: const EdgeInsets.all(5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recipe.label,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ).paddingV1,
                  titleValue(title: 'Ingredients: ', value: recipe.ingredientsStr).paddingV1,
                  titleValue(title: 'Calories: ', value: recipe.caloriesStr).paddingV1,
                  titleValue(title: 'Weight: ', value: recipe.totalWeightStr).paddingV1,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
