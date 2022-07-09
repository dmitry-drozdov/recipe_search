import 'package:flutter/material.dart';
import 'package:recipe_search/models/enums/diet_label.dart';
import 'package:recipe_search/models/enums/health_label.dart';
import 'package:recipe_search/viewmodels/recipe_viewmodel.dart';

import 'multi_select_field.dart';

class Params extends StatelessWidget {
  final RecipeViewModel recipeViewModel;
  final void Function() onApply;

  const Params({
    Key? key,
    required this.recipeViewModel,
    required this.onApply,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MultiSelectField<DietLabel>(
          items: DietLabel.values,
          onSelect: (values) {
            recipeViewModel.updateSearchSettings(newDietLabels: values.map((e) => e as DietLabel).toList());
          },
          title: 'Diet labels',
        ),
        const SizedBox(height: 5),
        MultiSelectField<HealthLabel>(
          items: HealthLabel.values,
          onSelect: (values) {
            recipeViewModel.updateSearchSettings(newHealthLabels: values.map((e) => e as HealthLabel).toList());
          },
          title: 'Health labels',
        ),
        Padding(
          padding: const EdgeInsets.all(0.0),
          child: TextButton(
            child: Text(
              'Apply',
              style: TextStyle(color: recipeViewModel.searchSettingsUpdated ? null : Colors.grey),
            ),
            onPressed: recipeViewModel.searchSettingsUpdated ? onApply : null,
            style: TextButton.styleFrom(padding: const EdgeInsets.all(0.0)),
          ),
        ),
      ],
    );
  }
}
