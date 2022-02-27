import 'package:flutter/material.dart';
import 'package:recipe_search/models/recipe/recipe_model.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../common.dart';

const verticalPadding = EdgeInsets.symmetric(vertical: 1);

final placeHolder = Icon(Icons.food_bank_outlined, color: Colors.grey.shade400, size: 65);

class RecipeCard extends StatelessWidget {
  final Recipe recipe;

  const RecipeCard({Key? key, required this.recipe}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(5),
        constraints: const BoxConstraints(maxHeight: 125),
        child: Row(
          children: [
            CachedNetworkImage(
              imageUrl: recipe.image,
              fit: BoxFit.contain,
              placeholder: (_, __) => placeHolder,
              width: 90,
            ),
            Container(
              width: 270,
              padding: const EdgeInsets.all(5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: verticalPadding,
                    child: Text(
                      recipe.label,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Padding(
                    padding: verticalPadding,
                    child: titleValue(title: 'Ingredients: ', value: recipe.ingredients.map((e) => e.food).join(', ')),
                  ),
                  Padding(
                    padding: verticalPadding,
                    child: titleValue(title: 'Calories: ', value: recipe.calories.toStringAsFixed(2)),
                  ),
                  Padding(
                    padding: verticalPadding,
                    child: titleValue(title: 'Weight: ', value: recipe.totalWeight.toStringAsFixed(2)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}