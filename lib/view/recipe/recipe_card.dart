import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:recipe_search/helpers/consts.dart';
import 'package:recipe_search/helpers/extensions/date_extension.dart';
import 'package:recipe_search/helpers/extensions/edge_extension.dart';
import 'package:recipe_search/models/recipe/recipe_model.dart';
import 'package:recipe_search/view/recipe/like_button.dart';

import '../../helpers/app_colors.dart';
import '../../viewmodels/recipe_viewmodel.dart';
import '../common/title_value.dart';

enum PageType { searchPage, favoritePage }

class RecipeCard extends StatelessWidget {
  final Recipe recipe;
  final void Function()? onTap;
  final RecipeViewModel viewModel;
  final PageType pageType;

  const RecipeCard({
    Key? key,
    required this.recipe,
    required this.onTap,
    required this.viewModel,
    required this.pageType,
  }) : super(key: key);

  bool get showSaveTime => pageType == PageType.favoritePage;

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
              removingConfirmation: pageType == PageType.favoritePage,
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
        constraints: BoxConstraints(maxHeight: 144 + (showSaveTime ? 16 : 0)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
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
                      titleValue(title: 'Calories (kcal): ', value: recipe.caloriesStr).paddingV1,
                      titleValue(title: 'Weight (g): ', value: recipe.totalWeightStr).paddingV1,
                      titleValue(title: 'Servings: ', value: recipe.servingsStr).paddingV1,
                    ],
                  ),
                ),
              ],
            ),
            if (showSaveTime)
              Text(
                'Saved: ${recipe.likeTimeOrNow.human}',
                style: const TextStyle(fontSize: 14, color: AppColors.grey),
              ),
          ],
        ),
      ),
    );
  }
}
