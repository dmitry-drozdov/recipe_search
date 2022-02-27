import 'package:recipe_search/models/recipe_model.dart';
import 'package:recipe_search/repositories/recipe_repo.dart';

import 'base_view_model.dart';

abstract class RecipeViewModel extends BaseViewModel<Recipe, void> {
  RecipeViewModel() : super();

  factory RecipeViewModel.create() => RecipeViewModelImpl();

  Future<void> loadRecipes();
}

class RecipeViewModelImpl extends RecipeViewModel {
  RecipeRepository recipeRepository = RecipeRepository.create();

  RecipeViewModelImpl() : super();

  @override
  Future<void> loadRecipes() async {
    recipeRepository.getRecipes(text: "Coffee");
  }
}
