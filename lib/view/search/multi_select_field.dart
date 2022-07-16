import 'package:flutter/material.dart';
import 'package:multi_select_flutter/chip_field/multi_select_chip_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:recipe_search/models/enums/diet_label.dart';
import 'package:recipe_search/models/enums/health_label.dart';

class MultiSelectField<T> extends StatefulWidget {
  final List<T> items;
  final List<T> initialItems;
  final Function(List) onSelect;
  final String title;

  const MultiSelectField({
    Key? key,
    required this.items,
    required this.onSelect,
    required this.title,
    required this.initialItems,
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
  }

  @override
  Widget build(BuildContext context) {
    return MultiSelectChipField(
      items: multiSelectItems.toList(),
      initialValue: widget.initialItems,
      title: Text(widget.title),
      headerColor: Colors.blue.withOpacity(0.4),
      decoration: BoxDecoration(border: Border.all(color: Colors.blue[700]!, width: 1.8)),
      selectedChipColor: Colors.blue.withOpacity(0.5),
      selectedTextStyle: TextStyle(color: Colors.blue[800]),
      onTap: (values) => widget.onSelect(values),
    );
  }
}
