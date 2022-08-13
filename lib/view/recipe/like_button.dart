import 'package:favorite_button/favorite_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../helpers/app_colors.dart';
import '../../helpers/consts.dart';
import '../../viewmodels/recipe_viewmodel.dart';

enum ExitType { cancel, removeNow, removeAlways }

class LikeButton extends StatefulWidget {
  final RecipeViewModel viewModel;
  final String recipeId;
  final bool removingConfirmation;

  const LikeButton({
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
            valueChanged: (_isFavorite) async {
              if (widget.removingConfirmation) {
                final result = await onRemoveLike(context);
                if (result == null || result == ExitType.cancel) {
                  setState(() => modifiedKey = DateTime.now());
                  return;
                }
              }
              // TODO handle removeAlways here (save to firestore flag)
              viewModel.addOrUpdateFavouriteRecipe(
                recipeId: widget.recipeId,
                timestamp: DateTime.now(),
                active: _isFavorite,
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
      builder: (BuildContext context) => AlertDialog(
        title: Text('Confirm removing', style: alertTextStyle),
        content: Text('Are you sure you want to remove this recipe from favorite list?', style: alertTextStyle),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, ExitType.removeAlways),
            child: Text('Yes, don\'t ask again', style: TextStyle(color: AppColors.redText)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, ExitType.removeNow),
            child: Text('Yes', style: TextStyle(color: AppColors.redLetter)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, ExitType.cancel),
            child: Text('Cancel', style: alertTextStyle),
          ),
        ],
      ),
    );
  }
}
