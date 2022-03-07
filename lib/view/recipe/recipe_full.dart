import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:recipe_search/helpers/consts.dart';
import 'package:recipe_search/models/recipe/recipe_model.dart';
import 'package:recipe_search/viewmodels/recipe_viewmodel.dart';
import 'package:recipe_search/viewmodels/viewmodel_provider.dart';

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
            child: CustomScrollView(
              slivers: <Widget>[
                SliverAppBar(
                 /* title: Title(
                    color: theme.backgroundColor,
                    child: Text(recipe.label),
                    title: recipe.label,
                  ),*/
                  backgroundColor: Colors.white,
                  pinned: true,
                  stretch: true,
                  expandedHeight: 260,
                  flexibleSpace: CachedNetworkImage(
                    imageUrl: recipe.bestImg!.url,
                    placeholder: (_, __) => placeholderLarge,
                    fit: BoxFit.fill,
                  ),
                ),
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      Container(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
