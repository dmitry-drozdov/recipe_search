import 'package:recipe_search/helpers/request_result_model.dart';
import 'package:http/http.dart' as http;
import '../secrets.dart';

abstract class RecipeRepository {
  RecipeRepository();

  factory RecipeRepository.create() {
    return RecipeRepositoryImpl();
  }

  Future<RequestResultModel> getRecipes({
    required String text,
  });
}


class RecipeRepositoryImpl extends RecipeRepository {

  RecipeRepositoryImpl();

  @override
  Future<RequestResultModel> getRecipes({required String text}) async {
    final query = 'https://api.edamam.com/search?q=$text&app_id=$applicationId&app_key=$applicationKey&from=0&to=20';
    final responce = await http.get(Uri.parse(query));
    return RequestResultModel(result: false);
  }
}
