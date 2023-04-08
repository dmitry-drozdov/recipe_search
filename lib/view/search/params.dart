import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_number_picker/flutter_number_picker.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';
import 'package:recipe_search/helpers/app_colors.dart';
import 'package:recipe_search/helpers/extensions/internet_status_extension.dart';
import 'package:recipe_search/helpers/extensions/widget_extension.dart';
import 'package:recipe_search/models/enums/diet_label.dart';
import 'package:recipe_search/models/enums/health_label.dart';
import 'package:recipe_search/models/enums/meal_type.dart';
import 'package:recipe_search/viewmodels/recipe_viewmodel.dart';

import '../../helpers/consts.dart';
import '../../main.dart';
import '../../utils/internet_checker.dart';
import 'multi_select_field.dart';

const divider = SizedBox(height: 7);
final buttonStyle = TextButton.styleFrom(padding: const EdgeInsets.all(0.0));
final buttonStyleLarge = TextButton.styleFrom(
  textStyle: const TextStyle(fontSize: 16),
  padding: const EdgeInsets.all(0.0),
);
final lineDivider = Divider(color: AppColors.blueBorder);

class Params extends StatefulWidget {
  final RecipeViewModel recipeViewModel;
  final void Function() onApply;

  const Params({
    Key? key,
    required this.recipeViewModel,
    required this.onApply,
  }) : super(key: key);

  @override
  State<Params> createState() => _ParamsState();
}

class _ParamsState extends State<Params> {
  late final StreamSubscription<InternetConnectionStatus> listener;
  final checker = locator<InternetChecker>();
  final controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    listener = checker.onStatusChange.listen((status) {
      if (mounted && status.disconnected) Navigator.of(context).pop();
    });
  }

  @override
  void dispose() {
    listener.cancel();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('All params')),
      body: consumerContent().padding8880,
    );
  }

  Widget consumerContent() {
    return ChangeNotifierProvider.value(
      value: widget.recipeViewModel,
      child: Consumer<RecipeViewModel>(
        builder: (ctx, _, __) {
          return Column(
            key: widget.recipeViewModel.searchSettingsCleared ? UniqueKey() : null,
            children: [
              Expanded(
                child: Scrollbar(
                  child: CustomScrollView(
                    slivers: <Widget>[
                      SliverList(delegate: SliverChildListDelegate(content(ctx))),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  List<Widget> content(BuildContext ctx) {
    final mealTypes = widget.recipeViewModel.searchSettings.mealTypes;
    final dietLabels = widget.recipeViewModel.searchSettings.dietLabels;
    final healthLabels = widget.recipeViewModel.searchSettings.healthLabels;
    return [
      MultiSelectField<MealType>(
        items: MealType.values,
        onSelect: (values) {
          widget.recipeViewModel.updateSearchSettings(newMealTypes: values.map((e) => e as MealType).toList());
        },
        title: 'Meal types ${suffix(mealTypes)}',
        initialItems: mealTypes,
        searchable: false,
      ),
      divider,
      MultiSelectField<DietLabel>(
        items: DietLabel.values,
        onSelect: (values) {
          widget.recipeViewModel.updateSearchSettings(newDietLabels: values.map((e) => e as DietLabel).toList());
        },
        title: 'Diet labels ${suffix(dietLabels)}',
        initialItems: dietLabels,
        searchable: false,
      ),
      divider,
      MultiSelectField<HealthLabel>(
        items: HealthLabel.values,
        onSelect: (values) {
          widget.recipeViewModel.updateSearchSettings(newHealthLabels: values.map((e) => e as HealthLabel).toList());
        },
        title: 'Health labels ${suffix(healthLabels)}',
        initialItems: healthLabels,
        searchable: true,
      ),
      lineDivider,
      caloriesRow(ctx),
      lineDivider,
      ingredientsRow(ctx),
      lineDivider,
      buttonsRow(ctx),
    ];
  }

  String suffix(List list) {
    return list.isEmpty ? "" : "(${list.length})";
  }

  Widget buttonsRow(BuildContext ctx) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        TextButton(
          onPressed: widget.recipeViewModel.searchSettingsUpdated
              ? () {
                  if (ctx.mounted) Navigator.of(ctx).pop();
                  widget.onApply();
                }
              : null,
          style: buttonStyle,
          child: Text(
            'Apply',
            style: TextStyle(color: widget.recipeViewModel.searchSettingsUpdated ? null : Colors.grey, fontSize: 16),
          ),
        ),
        TextButton(
          onPressed: widget.recipeViewModel.searchSettingsCleared
              ? null
              : () => widget.recipeViewModel.updateSearchSettings(clearSettings: true),
          style: buttonStyle,
          child: Text(
            'Reset',
            style: TextStyle(color: widget.recipeViewModel.searchSettingsCleared ? Colors.grey : null, fontSize: 16),
          ),
        ),
      ],
    );
  }

  Widget caloriesRow(BuildContext ctx) {
    final settingsMin = widget.recipeViewModel.searchSettings.caloriesRange.min;
    final settingsMax = widget.recipeViewModel.searchSettings.caloriesRange.max;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Calories from', style: mainFont),
        CustomNumberPicker(
          shape: numberPickerShape,
          initialValue: settingsMin,
          maxValue: settingsMax,
          minValue: 0,
          step: 100,
          onValue: (value) {
            widget.recipeViewModel.updateSearchSettings(caloriesMin: value as int);
          },
        ),
        const Text('to', style: mainFont),
        CustomNumberPicker(
          shape: numberPickerShape,
          initialValue: settingsMax,
          maxValue: 10000,
          minValue: settingsMin,
          step: 100,
          onValue: (value) {
            widget.recipeViewModel.updateSearchSettings(caloriesMax: value as int);
          },
        ),
        const Text('/ serv', style: mainFont),
      ],
    );
  }

  Widget ingredientsRow(BuildContext ctx) {
    final settingsMin = widget.recipeViewModel.searchSettings.ingredientsRange.min;
    final settingsMax = widget.recipeViewModel.searchSettings.ingredientsRange.max;
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
            widget.recipeViewModel.updateSearchSettings(ingredientsMin: value as int);
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
            widget.recipeViewModel.updateSearchSettings(ingredientsMax: value as int);
          },
        ),
        const SizedBox(),
      ],
    );
  }
}
