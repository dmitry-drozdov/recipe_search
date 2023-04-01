import 'package:favorite_button/favorite_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../helpers/app_colors.dart';
import '../../viewmodels/recipe_viewmodel.dart';
import '../common/confirm_dialog.dart';

class LikeButton extends StatefulWidget {
  final RecipeViewModel viewModel;
  final String recipeId;
  final bool removingConfirmation;

  LikeButton({
    Key? key,
    required this.viewModel,
    required this.recipeId,
    required this.removingConfirmation,
  }) : super(key: key);

  @override
  State<LikeButton> createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> {
  DateTime modifiedKey = DateTime.now(); // to force like updating when user decided not to remove item

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: widget.viewModel,
      child: Consumer<RecipeViewModel>(
        builder: (_, viewModel, ___) {
          final isFavorite = viewModel.favoriteIds.contains(widget.recipeId);
          return FavoriteButton(
            key: Key('FavoriteButton$isFavorite${widget.recipeId}$modifiedKey'),
            isFavorite: isFavorite,
            iconColor: AppColors.redLetter,
            iconDisabledColor: AppColors.greyLike,
            valueChanged: (val) async {
              if (widget.removingConfirmation && viewModel.askBeforeRemoving) {
                final result = await onRemoveLike(context);
                if (result == null || result == ExitType.cancel) {
                  setState(() => modifiedKey = DateTime.now());
                  return;
                }
                if (result == ExitType.yesAlways) {
                  viewModel.updateUserSettings(askBeforeRemoving: false);
                }
              }

              viewModel.addOrUpdateFavouriteRecipe(
                recipeId: widget.recipeId,
                timestamp: DateTime.now(),
                active: val,
              );
            },
          );
        },
      ),
    );
  }

  Future<ExitType?> onRemoveLike(BuildContext ctx) async {
    return await showDialog<ExitType>(
      context: ctx,
      builder: (BuildContext context) => ConfirmDialog(
        title: 'Confirm removing',
        content: 'Are you sure you want to remove this recipe from favorite list?',
        yesAlwaysText: 'Yes always',
      ),
    );
  }
}
