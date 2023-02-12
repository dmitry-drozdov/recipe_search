import 'package:flutter/material.dart';
import 'package:multi_select_flutter/chip_field/multi_select_chip_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:recipe_search/helpers/app_colors.dart';
import 'package:recipe_search/models/enums/diet_label.dart';
import 'package:recipe_search/models/enums/health_label.dart';
import 'package:recipe_search/models/enums/meal_type.dart';

class MultiSelectField<T> extends StatefulWidget {
  final List<T> items;
  final List<T> initialItems;
  final Function(List) onSelect;
  final String title;
  final bool searchable;

  const MultiSelectField({
    Key? key,
    required this.items,
    required this.onSelect,
    required this.title,
    required this.initialItems,
    required this.searchable,
  }) : super(key: key);

  @override
  State<MultiSelectField> createState() => _MultiSelectFieldState();
}

class _MultiSelectFieldState extends State<MultiSelectField> {
  Iterable<MultiSelectItem<Object?>> multiSelectItems = [];

  @override
  void initState() {
    super.initState();
    if (widget.items.runtimeType == List<DietLabel>) {
      multiSelectItems = widget.items.map((e) => MultiSelectItem<DietLabel?>(e as DietLabel, e.view));
      return;
    }
    if (widget.items.runtimeType == List<HealthLabel>) {
      multiSelectItems = widget.items.map((e) => MultiSelectItem<HealthLabel?>(e as HealthLabel, e.view));
      return;
    }
    if (widget.items.runtimeType == List<MealType>) {
      multiSelectItems = widget.items
          .where((e) => e != MealType.lunchDinner)
          .map((e) => MultiSelectItem<MealType?>(e as MealType, e.view));
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiSelectChipField(
      items: multiSelectItems.toList(),
      initialValue: widget.initialItems,
      title: Text(widget.title),
      headerColor: AppColors.lightBlueChip,
      decoration: BoxDecoration(border: Border.all(color: AppColors.blueBorder, width: 1.8)),
      selectedChipColor: AppColors.lightBlueChip,
      selectedTextStyle: const TextStyle(color: AppColors.black),
      onTap: (values) => widget.onSelect(values),
      searchable: widget.searchable,
      searchHint: 'Enter search text...',
    );
  }
}
