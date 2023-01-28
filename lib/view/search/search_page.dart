import 'dart:async';

import 'package:expandable/expandable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';
import 'package:recipe_search/helpers/extensions/internet_status_extension.dart';
import 'package:recipe_search/helpers/extensions/widget_extension.dart';
import 'package:recipe_search/helpers/widgets/linear_loading.dart';
import 'package:recipe_search/view/recipe/recipe_list.dart';
import 'package:recipe_search/view/search/params.dart';
import 'package:recipe_search/viewmodels/recipe_viewmodel.dart';
import 'package:recipe_search/viewmodels/viewmodel_provider.dart';

import '../../main.dart';
import '../../utils/internet_checker.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({
    Key? key,
    this.user,
    this.deviceId,
  })  : assert(user != null || deviceId != null),
        super(key: key);

  final User? user;
  final String? deviceId;

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late final RecipeViewModel recipeViewModel;
  late final StreamSubscription subscription;
  late final StreamSubscription<InternetConnectionStatus> listener;

  final checker = locator<InternetChecker>();
  final controller = TextEditingController();
  final expandableController = ExpandableController();
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
      create: () => RecipeViewModel.create(widget.user?.uid ?? widget.deviceId ?? 'unknown'),
    );
    listener = checker.onStatusChange.listen((status) {
      if (expandableController.expanded && status.disconnected) {
        expandableController.expanded = false;
      }
      if (mounted) setState(() {});
    });
    updateTextController();
    subscription = recipeViewModel.startUIListening((event) {
      switch (event) {
        case RecipeEvent.hideParams:
          updateTextController();
          if (expandableController.expanded) {
            expandableController.expanded = false;
          }
          break;
        case RecipeEvent.openAllParams:
          if (!mounted) return;
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => Params(
                key: Key('params${recipeViewModel.searchSettings.hashCode}'),
                screenMode: ScreenMode.full,
                onApply: _loadRecipes,
                recipeViewModel: recipeViewModel,
              ),
            ),
          );
          break;
        case RecipeEvent.openRecipe:
          break;
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
    expandableController.dispose();
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
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 4),
              child: TextButton(
                onPressed: _loadRecipes,
                child: const Text('Search'),
              ),
            ),
          ],
        ).hide(checker.disconnected),
        ChangeNotifierProvider.value(
          value: recipeViewModel,
          child: Consumer<RecipeViewModel>(
            builder: (_, viewModel, ___) {
              return buildParams();
            },
          ),
        ).hide(checker.disconnected),
        const Flexible(child: RecipeList()),
      ],
    );
  }

  Widget buildParams() {
    return ExpandablePanel(
      header: const Text('Params', style: TextStyle(fontSize: 18)),
      theme: ExpandableThemeData(
        headerAlignment: ExpandablePanelHeaderAlignment.center,
        iconColor: Theme.of(context).primaryColor,
        animationDuration: const Duration(milliseconds: 400),
        scrollAnimationDuration: const Duration(milliseconds: 400),
      ),
      controller: expandableController,
      collapsed: Container(),
      expanded: Params(
        key: Key('searchPageParams${recipeViewModel.searchSettings.hashCode}'),
        recipeViewModel: recipeViewModel,
        onApply: _loadRecipes,
        screenMode: ScreenMode.part,
      ),
    ).padding8880;
  }
}
