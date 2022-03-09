import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:recipe_search/helpers/consts.dart';
import 'package:recipe_search/helpers/list_extension.dart';
import 'package:recipe_search/models/recipe/recipe_model.dart';
import 'package:recipe_search/viewmodels/recipe_viewmodel.dart';
import 'package:recipe_search/viewmodels/viewmodel_provider.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';

class Title extends StatelessWidget {
  final String title;
  final Color? color;
  final FontWeight? fontWeight;

  const Title({
    Key? key,
    required this.title,
    this.color,
    this.fontWeight = FontWeight.w500,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      color: color ?? Colors.indigo.withOpacity(0.1),
      child: Text(title, style: TextStyle(fontSize: 20, fontWeight: fontWeight)),
    );
  }
}

class TitleValue extends StatelessWidget {
  final String title;
  final String value;
  final Color? color;

  const TitleValue({
    Key? key,
    required this.title,
    required this.value,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2),
      padding: const EdgeInsets.all(8.0),
      color: color ?? Colors.indigo.withOpacity(0.1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
          Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w400)),
        ],
      ),
    );
  }
}

class Value extends StatelessWidget {
  final String value;
  final double? fontSize;

  const Value({
    Key? key,
    required this.value,
    this.fontSize = 18,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(value, style: TextStyle(fontSize: fontSize)),
    );
  }
}

class LinkValue extends StatelessWidget {
  final String value;
  final Color color;

  const LinkValue({Key? key, required this.value, required this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Linkify(
        onOpen: (link) async {
          if (await canLaunch(link.url)) {
            await launch(link.url);
          } else {
            throw 'Could not launch $link';
          }
        },
        text: value,
        linkStyle: TextStyle(fontSize: 18, color: color),
        options: const LinkifyOptions(removeWww: true),
      ),
    );
  }
}

class CircleInfo extends StatelessWidget {
  final String title;
  final String value;
  final Color borderColor;

  const CircleInfo({Key? key, required this.title, required this.value, required this.borderColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: borderColor.withOpacity(0.05),
        border: Border.all(color: borderColor, width: 2),
        borderRadius: const BorderRadius.all(Radius.circular(100)),
      ),
      height: 100,
      width: 100,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
          ),
          Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}

class RecipeFull extends StatefulWidget {
  final String id;

  const RecipeFull({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  State<RecipeFull> createState() => _RecipeFullState();
}

class _RecipeFullState extends State<RecipeFull> {
  final recipeViewModel = ViewModelProvider.get<RecipeViewModel>(recipeKey);
  late final Recipe recipe;

  @override
  void initState() {
    super.initState();
    recipe = recipeViewModel.items.firstWhere((element) => element.id == widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            child: Scrollbar(
              child: CustomScrollView(
                slivers: <Widget>[
                  SliverAppBar(
                    leadingWidth: 40,
                    leading: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: RawMaterialButton(
                        onPressed: () => Navigator.of(context).pop(),
                        elevation: 2.0,
                        fillColor: Colors.indigo.withOpacity(0.3),
                        child: const Icon(Icons.arrow_back_rounded, size: 35.0),
                        shape: const CircleBorder(),
                      ),
                    ),
                    backgroundColor: Colors.white,
                    pinned: true,
                    stretch: true,
                    expandedHeight: 260,
                    flexibleSpace: CachedNetworkImage(
                      imageUrl: recipe.bestImg!.url,
                      placeholder: (_, __) => placeholderLarge,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate(getContentWidgets()),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> getContentWidgets() {
    final theme = Theme.of(context);
    final blueColor = theme.primaryColor.withOpacity(0.1);
    return [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          recipe.label,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500, color: Colors.indigo),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            CircleInfo(
              title: 'Weight',
              value: recipe.totalWeight.toStringAsFixed(0),
              borderColor: theme.primaryColor,
            ),
            CircleInfo(
              title: 'Calories',
              value: recipe.calories.toStringAsFixed(0),
              borderColor: theme.primaryColor,
            ),
          ],
        ),
      ),
      //-----------------------------------------------
      if (recipe.ingredients.isNotEmpty) ...[
        const Title(title: 'Ingredients', fontWeight: FontWeight.w600),
        Value(
          value: recipe.ingredients.map((e) => e.food).join(', '),
          fontSize: 20,
        ),
      ],
      //-----------------------------------------------
      if (recipe.cautions.isNotEmpty) ...[
        Title(title: 'Cautions', color: Colors.red.withOpacity(0.1)),
        Value(value: recipe.cautions.view),
      ],
      //-----------------------------------------------
      if (recipe.cuisineType.isNotEmpty) ...[
        const Title(title: 'Cuisine type'),
        Value(value: recipe.cuisineType.view),
      ],
      //-----------------------------------------------
      if (recipe.dietLabels.isNotEmpty) ...[
        const Title(title: 'Diet labels'),
        Value(value: recipe.dietLabels.view),
      ],
      //-----------------------------------------------
      if (recipe.dishType.isNotEmpty) ...[
        const Title(title: 'Dish type'),
        Value(value: recipe.dishType.view),
      ],
      //-----------------------------------------------
      if (recipe.mealType.isNotEmpty) ...[
        const Title(title: 'Meal type'),
        Value(value: recipe.mealType.view),
      ],
      //-----------------------------------------------
      if (recipe.healthLabels.isNotEmpty) ...[
        const Title(title: 'Health labels'),
        Value(value: recipe.healthLabels.view),
      ],
      //-----------------------------------------------
      if (recipe.glycemicIndex != null)
        TitleValue(title: 'Glycemic index', value: recipe.glycemicIndex.toString(), color: blueColor),
      //-----------------------------------------------
      if (recipe.totalCO2Emissions != null)
        TitleValue(
          title: 'Total CO2 Emissions',
          value: recipe.totalCO2Emissions.toString(),
          color: blueColor,
        ),
      //-----------------------------------------------
      if (recipe.co2EmissionsClass != null)
        TitleValue(title: 'CO2 Emissions Class', value: recipe.co2EmissionsClass!, color: blueColor),
      //-----------------------------------------------
      const Title(title: 'Ingredients details', fontWeight: FontWeight.w600),
      Value(value: listMarker + recipe.ingredientLines.join('\n$listMarker'), fontSize: 20),

      const Title(title: 'Link'),
      LinkValue(value: recipe.shareAs, color: theme.primaryColor),
    ];
  }
}
