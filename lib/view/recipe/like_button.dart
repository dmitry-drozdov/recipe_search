import 'package:favorite_button/favorite_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../helpers/app_colors.dart';
import '../../viewmodels/recipe_viewmodel.dart';

class LikeButton extends StatelessWidget {
  final RecipeViewModel viewModel;
  final String recipeId;

  const LikeButton({
    Key? key,
    required this.viewModel,
    required this.recipeId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: viewModel,
      child: Consumer<RecipeViewModel>(
        builder: (_, viewModel, ___) {
          return FavoriteButton(
            isFavorite: viewModel.favoriteIds.contains(recipeId),
            iconDisabledColor: AppColors.greyLike,
            valueChanged: (_isFavorite) {
              viewModel.addOrUpdateFavouriteRecipe(
                recipeId: recipeId,
                timestamp: DateTime.now(),
                active: _isFavorite,
              );
            },
          );
        },
      ),
    );
  }
}
