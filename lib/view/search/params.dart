import 'package:flutter/material.dart';
import 'package:flutter_number_picker/flutter_number_picker.dart';
import 'package:provider/provider.dart';
import 'package:recipe_search/helpers/app_colors.dart';
import 'package:recipe_search/helpers/extensions/widget_extension.dart';
import 'package:recipe_search/models/enums/diet_label.dart';
import 'package:recipe_search/models/enums/health_label.dart';
import 'package:recipe_search/models/enums/meal_type.dart';
import 'package:recipe_search/viewmodels/recipe_viewmodel.dart';

import '../../helpers/consts.dart';
import 'multi_select_field.dart';

const divider = SizedBox(height: 5);
final buttonStyle = TextButton.styleFrom(padding: const EdgeInsets.all(0.0));
final buttonStyleLarge = TextButton.styleFrom(
  textStyle: const TextStyle(fontSize: 16),
  padding: const EdgeInsets.all(0.0),
);
final lineDivider = Divider(color: AppColors.blueBorder);

class Params extends StatelessWidget {
  final RecipeViewModel recipeViewModel;
  final void Function() onApply;

  Params({
    Key? key,
    required this.recipeViewModel,
    required this.onApply,
  }) : super(key: key);

  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('All params')),
      body: consumerContent().padding8880,
    );
  }

  Widget consumerContent() {
    return ChangeNotifierProvider.value(
      value: recipeViewModel,
      child: Consumer<RecipeViewModel>(builder: (ctx, _, __) => content(ctx)),
    );
  }

  Widget content(BuildContext ctx) {
    return Column(
      children: [
        MultiSelectField<DietLabel>(
          items: DietLabel.values,
          onSelect: (values) {
            recipeViewModel.updateSearchSettings(newDietLabels: values.map((e) => e as DietLabel).toList());
          },
          title: 'Diet labels',
          initialItems: recipeViewModel.searchSettings.dietLabels,
        ),
        divider,
        MultiSelectField<HealthLabel>(
          items: HealthLabel.values,
          onSelect: (values) {
            recipeViewModel.updateSearchSettings(newHealthLabels: values.map((e) => e as HealthLabel).toList());
          },
          title: 'Health labels',
          initialItems: recipeViewModel.searchSettings.healthLabels,
        ),
        divider,
        MultiSelectField<MealType>(
          items: MealType.values,
          onSelect: (values) {
            recipeViewModel.updateSearchSettings(newMealTypes: values.map((e) => e as MealType).toList());
          },
          title: 'Meal types',
          initialItems: recipeViewModel.searchSettings.mealTypes,
        ),
        lineDivider,
        caloriesRow(ctx),
        lineDivider,
        ingredientsRow(ctx),
        lineDivider,
        buttonsRow(ctx),
      ],
    );
  }

  Widget buttonsRow(BuildContext ctx) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(
          onPressed: recipeViewModel.searchSettingsUpdated
              ? () {
                  if (ctx.mounted) Navigator.of(ctx).pop();
                  onApply();
                }
              : null,
          style: buttonStyle,
          child: Text(
            'Apply',
            style: TextStyle(color: recipeViewModel.searchSettingsUpdated ? null : Colors.grey, fontSize: 16),
          ),
        ),
      ],
    );
  }

  Widget caloriesRow(BuildContext ctx) {
    final settingsMin = recipeViewModel.searchSettings.caloriesRange.min;
    final settingsMax = recipeViewModel.searchSettings.caloriesRange.max;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Calories from', style: mainFont),
        CustomNumberPicker(
          shape: numberPickerShape,
          initialValue: settingsMin,
          maxValue: settingsMax,
          minValue: 0,
          step: 10,
          onValue: (value) {
            recipeViewModel.updateSearchSettings(caloriesMin: value as int);
          },
        ),
        const Text('to', style: mainFont),
        CustomNumberPicker(
          shape: numberPickerShape,
          initialValue: settingsMax,
          maxValue: 10000,
          minValue: settingsMin,
          step: 10,
          onValue: (value) {
            recipeViewModel.updateSearchSettings(caloriesMax: value as int);
          },
        ),
        const Text('/ serv', style: mainFont),
      ],
    );
  }

  Widget ingredientsRow(BuildContext ctx) {
    final settingsMin = recipeViewModel.searchSettings.ingredientsRange.min;
    final settingsMax = recipeViewModel.searchSettings.ingredientsRange.max;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Ingredients from', style: mainFont),
        CustomNumberPicker(
          shape: numberPickerShape,
          initialValue: settingsMin,
          maxValue: settingsMax,
          minValue: 0,
          step: 1,
          onValue: (value) {
            recipeViewModel.updateSearchSettings(ingredientsMin: value as int);
          },
        ),
        const Text('to', style: mainFont),
        CustomNumberPicker(
          shape: numberPickerShape,
          initialValue: settingsMax,
          maxValue: 20,
          minValue: settingsMin,
          step: 1,
          onValue: (value) {
            recipeViewModel.updateSearchSettings(ingredientsMax: value as int);
          },
        ),
        const SizedBox(),
      ],
    );
  }
}
