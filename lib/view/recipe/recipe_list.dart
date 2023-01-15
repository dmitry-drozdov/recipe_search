import 'dart:async';

import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';
import 'package:recipe_search/utils/internet_checker.dart';
import 'package:recipe_search/view/recipe/recipe_card.dart';
import 'package:recipe_search/view/recipe/recipe_full.dart';
import 'package:recipe_search/viewmodels/recipe_viewmodel.dart';
import 'package:recipe_search/viewmodels/viewmodel_provider.dart';

import '../../main.dart';

class RecipeList extends StatefulWidget {
  const RecipeList({Key? key}) : super(key: key);

  @override
  State<RecipeList> createState() => _RecipeListState();
}

class _RecipeListState extends State<RecipeList> {
  final recipeViewModel = ViewModelProvider.get<RecipeViewModel>(recipeKey);
  final scrollController = ScrollController();
  final checker = locator<InternetChecker>();

  late final StreamSubscription<InternetConnectionStatus> listener;
  late final StreamSubscription subscription;

  @override
  void initState() {
    super.initState();
    listener = checker.onStatusChange.listen((_) {
      if (mounted) setState(() {});
    });
    subscription = recipeViewModel.startUIListening((event) {
      switch (event) {
        case RecipeEvent.openRecipe:
          if (!mounted) {
            return;
          }
          final id = recipeViewModel.currentRecipeId;
          if (id == null) {
            throw Exception('Cannot open recipe full page. It was null');
          }
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => RecipeFull(key: Key('recipeFull$id'), id: id)),
          );
          break;
        case RecipeEvent.hideParams:
        case RecipeEvent.openAllParams:
        case RecipeEvent.openDigest:
          break;
      }
    });
    scrollController.addListener(() {
      recipeViewModel.uiEventSubject.add(RecipeEvent.hideParams);
    });
  }

  @override
  void dispose() {
    recipeViewModel.removeUIListeners(subscription);
    listener.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: recipeViewModel,
      child: Consumer<RecipeViewModel>(
        builder: (_, viewModel, ___) {
          if (checker.noInternet) {
            return noInternet();
          }
          if (viewModel.count == 0 && !recipeViewModel.loading) {
            return noResult();
          }
          return ListView.builder(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            controller: scrollController,
            itemBuilder: (ctx, i) {
              if (i == viewModel.items.length - 1 && !viewModel.loading) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  viewModel.loadRecipesNextPage();
                });
              }
              final element = viewModel.items[i];
              final id = element.id;
              return RecipeCard(
                key: Key('recipeCard$id'),
                recipe: element,
                onTap: viewModel.processingIds.contains(id) ? null : () => viewModel.onRecipeTap(id: id),
                viewModel: viewModel,
                pageType: PageType.searchPage,
              );
            },
            itemCount: viewModel.items.length,
          );
        },
      ),
    );
  }

  Widget noResult() {
    final text =
        recipeViewModel.searchSettings.emptySearchText ? "Please enter what do you want to find" : "No results found";
    return Align(
      alignment: Alignment.center,
      child: Column(
        children: [
          Icon(
            Icons.search,
            size: 220,
            color: Theme.of(context).primaryColor.withOpacity(0.3),
          ),
          Text(
            text,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget noInternet() {
    return Align(
      alignment: Alignment.center,
      child: Column(
        children: [
          Icon(
            Icons.cell_wifi_rounded,
            size: 220,
            color: Theme.of(context).primaryColor.withOpacity(0.3),
          ),
          const Text(
            'No internet connection',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
