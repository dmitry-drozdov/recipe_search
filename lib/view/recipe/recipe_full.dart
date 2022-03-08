import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:recipe_search/helpers/consts.dart';
import 'package:recipe_search/helpers/list_extension.dart';
import 'package:recipe_search/models/recipe/recipe_model.dart';
import 'package:recipe_search/viewmodels/recipe_viewmodel.dart';
import 'package:recipe_search/viewmodels/viewmodel_provider.dart';

class Title extends StatelessWidget {
  final String title;
  final Color? color;

  const Title({Key? key, required this.title, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      color: color ?? Colors.indigo.withOpacity(0.1),
      child: Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
    );
  }
}

class Value extends StatelessWidget {
  final String value;

  const Value({Key? key, required this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(value, style: const TextStyle(fontSize: 18)),
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
    final theme = Theme.of(context);
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
                    delegate: SliverChildListDelegate(
                      [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            recipe.label,
                            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500, color: Colors.indigo),
                          ),
                        ),
                        //-----------------------------------------------
                        if (recipe.ingredients.isNotEmpty) ...[
                          const Title(title: 'Ingredients'),
                          Value(value: recipe.ingredients.map((e) => e.food).join(', ')),
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

                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
