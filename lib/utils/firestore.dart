import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:recipe_search/helpers/extensions/date_extension.dart';
import 'package:recipe_search/helpers/extensions/search_settings_extension.dart';
import 'package:recipe_search/helpers/extensions/user_extension.dart';
import 'package:recipe_search/models/search_settings.dart';

class Storage {
  static final _userSessions = FirebaseFirestore.instance.collection('userSessions');
  static final _searches = FirebaseFirestore.instance.collection('searches');
  static final _favouriteRecipes = FirebaseFirestore.instance.collection('favouriteRecipes');

  static void logUserSession(User user, DateTime timestamp) async {
    final id = 'U${timestamp.customIso861}|${user.email}';
    _userSessions.doc(id).set({
      'user': user.marshal,
      'timestamp': timestamp,
    });
  }

  static void logSearch({
    required SearchSettings searchSettings,
    required bool firstPage,
    required DateTime timestamp,
    int? errorCode,
  }) {
    final id = 'S${timestamp.customIso861}|${searchSettings.hashCode}';
    _searches.doc(id).set({
      'search': searchSettings.marshal,
      'firstPage': firstPage,
      'errorCode': errorCode,
      'timestamp': timestamp,
    });
  }

  static Future<void> addOrUpdateFavouriteRecipe({
    // required User user,
    required String recipeId,
    required DateTime timestamp,
    required bool active,
  }) async {
    final id = 'USER12'; //'F${user.uid}';
    final document = await _favouriteRecipes.doc(id).get();
    final map = document.data() ?? <String, dynamic>{};
    map[recipeId] = {
      'active': active,
      'timestamp': timestamp,
    };

    _favouriteRecipes.doc(id).set(map);
  }
}
