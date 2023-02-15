import 'dart:async';

import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';
import 'package:recipe_search/helpers/app_colors.dart';
import 'package:recipe_search/helpers/extensions/widget_extension.dart';
import 'package:recipe_search/helpers/widgets/linear_loading.dart';
import 'package:recipe_search/models/app_user.dart';
import 'package:recipe_search/view/recipe/recipe_list.dart';
import 'package:recipe_search/view/search/params.dart';
import 'package:recipe_search/viewmodels/recipe_viewmodel.dart';
import 'package:recipe_search/viewmodels/viewmodel_provider.dart';

import '../../main.dart';
import '../../utils/internet_checker.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({
    Key? key,
    required this.user,
  }) : super(key: key);

  final AppUser user;

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late final RecipeViewModel recipeViewModel;
  late final StreamSubscription subscription;
  late final StreamSubscription<InternetConnectionStatus> listener;

  final checker = locator<InternetChecker>();
  final controller = TextEditingController();
  final focusNode = FocusNode();

  String searchText = '';

  Future<void> _loadRecipes() async {
    final trimmedSearch = searchText.trim();
    if (trimmedSearch != recipeViewModel.searchSettings.search) {
      recipeViewModel.updateSearchSettings(newSearch: trimmedSearch);
    }
    await recipeViewModel.loadRecipesFirstPage();
    focusNode.unfocus();
  }

  void updateTextController() {
    searchText = recipeViewModel.searchSettings.search;
    controller.text = searchText;
  }

  @override
  void initState() {
    super.initState();
    recipeViewModel = ViewModelProvider.getOrCreate(
      key: recipeKey,
      create: () => RecipeViewModel.create(widget.user.userId),
    );
    listener = checker.onStatusChange.listen((status) {
      if (mounted) setState(() {});
    });
    updateTextController();
    subscription = recipeViewModel.startUIListening((event) {
      switch (event) {
        case RecipeEvent.openAllParams:
          if (!mounted) return;
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => Params(
                key: Key('params${recipeViewModel.searchSettings.hashCode}'),
                onApply: _loadRecipes,
                recipeViewModel: recipeViewModel,
              ),
            ),
          );
          break;
        case RecipeEvent.userLoaded:
          updateTextController();
          break;
        case RecipeEvent.openRecipe:
        case RecipeEvent.openDigest:
          break;
      }
    });
  }

  @override
  void dispose() {
    listener.cancel();
    recipeViewModel.removeUIListeners(subscription);
    controller.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ChangeNotifierProvider.value(
          value: recipeViewModel,
          child: Consumer<RecipeViewModel>(
            builder: (_, viewModel, ___) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: LinearLoading(
                  Theme.of(context).primaryColor,
                  show: recipeViewModel.loading,
                ),
              );
            },
          ),
        ),
        Row(
          children: [
            Flexible(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 4),
                child: TextField(
                  controller: controller,
                  focusNode: focusNode,
                  onChanged: (value) => searchText = value,
                  onEditingComplete: _loadRecipes,
                  textInputAction: TextInputAction.search,
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.search, color: AppColors.blueBorder),
              onPressed: _loadRecipes,
            ),
            IconButton(
              icon: Icon(Icons.settings_outlined, color: AppColors.blueBorder),
              onPressed: () => recipeViewModel.onAllParamsTap(),
            ),
          ],
        ).hide(checker.disconnected),
        const Flexible(child: RecipeList()),
      ],
    );
  }
}
