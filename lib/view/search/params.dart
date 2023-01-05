import 'package:flutter/material.dart';
import 'package:flutter_number_picker/flutter_number_picker.dart';
import 'package:provider/provider.dart';
import 'package:recipe_search/helpers/extensions/edge_extension.dart';
import 'package:recipe_search/models/enums/diet_label.dart';
import 'package:recipe_search/models/enums/health_label.dart';
import 'package:recipe_search/viewmodels/recipe_viewmodel.dart';

import '../../helpers/consts.dart';
import 'multi_select_field.dart';

const divider = SizedBox(height: 5);
final buttonStyle = TextButton.styleFrom(padding: const EdgeInsets.all(0.0));
final buttonStyleLarge = TextButton.styleFrom(
  textStyle: const TextStyle(fontSize: 16),
  padding: const EdgeInsets.all(0.0),
);

enum ScreenMode { part, full }

class Params extends StatelessWidget {
  final RecipeViewModel recipeViewModel;
  final void Function() onApply;
  final ScreenMode screenMode;

  Params({
    Key? key,
    required this.recipeViewModel,
    required this.onApply,
    required this.screenMode,
  }) : super(key: key);

  final controller = TextEditingController();

  bool get partScreen => screenMode == ScreenMode.part;
  bool get fullScreen => screenMode == ScreenMode.full;

  @override
  Widget build(BuildContext context) {
    if (partScreen) {
      return consumerContent();
    }
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
        caloriesRow(ctx),
        buttonsRow(ctx),
      ],
    );
  }

  Widget buttonsRow(BuildContext ctx) {
    return Row(
      mainAxisAlignment: partScreen ? MainAxisAlignment.spaceBetween : MainAxisAlignment.center,
      children: [
        if (partScreen) const SizedBox(width: 15),
        TextButton(
          child: Text(
            'Apply',
            style: TextStyle(color: recipeViewModel.searchSettingsUpdated ? null : Colors.grey),
          ),
          onPressed: recipeViewModel.searchSettingsUpdated
              ? () {
                  if (fullScreen) Navigator.of(ctx).pop();
                  onApply();
                }
              : null,
          style: buttonStyle,
        ),
        if (partScreen)
          TextButton(
            child: const Text('All params'),
            onPressed: recipeViewModel.onAllParamsTap,
            style: buttonStyle,
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
          enable: true,
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
          enable: true,
          onValue: (value) {
            recipeViewModel.updateSearchSettings(caloriesMax: value as int);
          },
        )
      ],
    );
  }
}
