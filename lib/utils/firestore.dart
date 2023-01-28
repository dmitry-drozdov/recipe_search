import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:recipe_search/helpers/extensions/date_extension.dart';
import 'package:recipe_search/helpers/extensions/user_extension.dart';
import 'package:recipe_search/models/search_settings.dart';
import 'package:recipe_search/models/user_settings.dart';

typedef FavouriteData = Map<String, DateTime>;

const cacheSize = 50 * 1024 * 1024; // 50 MB

class FirebaseStorage {
  final _userSessions = FirebaseFirestore.instance.collection('userSessions');
  final _userSettings = FirebaseFirestore.instance.collection('userSettings');
  final _searches = FirebaseFirestore.instance.collection('searches');
  final _favouriteRecipes = FirebaseFirestore.instance.collection('favouriteRecipes');

  FirebaseStorage() {
    FirebaseFirestore.instance.settings = const Settings(
      persistenceEnabled: true,
      cacheSizeBytes: cacheSize,
    );
  }

  // ------------------- logs -------------------
  void logUserSession(User user, DateTime timestamp) async {
    final id = 'U${timestamp.customIso861}|${user.email}';
    _userSessions.doc(id).set({
      'user': user.marshal,
      'timestamp': timestamp,
    });
  }

  void logSearch({
    required SearchSettings searchSettings,
    required bool firstPage,
    required DateTime timestamp,
    int? errorCode,
  }) {
    final id = 'S${timestamp.customIso861}|${searchSettings.hashCode}';
    _searches.doc(id).set({
      'search': searchSettings.toJson(),
      'firstPage': firstPage,
      'errorCode': errorCode,
      'timestamp': timestamp,
    });
  }

  // ------------------- favourite recipes -------------------

  Future<void> addOrUpdateFavouriteRecipe({
    required String userId,
    required String recipeId,
    required DateTime timestamp,
    required bool active,
  }) async {
    final id = 'F$userId';
    final document = await _favouriteRecipes.doc(id).get();
    final map = document.data() ?? <String, dynamic>{};
    map[recipeId] = {
      'active': active,
      'timestamp': timestamp,
    };
    _favouriteRecipes.doc(id).set(map);
    log('addOrUpdateFavouriteRecipe: $id $map');
  }

  Future<FavouriteData> getFavouriteRecipes({
    required String userId,
  }) async {
    try {
      final id = 'F$userId';
      final document = await _favouriteRecipes.doc(id).get();
      final map = document.data() ?? <String, dynamic>{};
      final FavouriteData result = {};
      map.forEach((key, value) {
        if (value is Map<String, dynamic> && value['active'] == true && value['timestamp'] is Timestamp) {
          result[key] = (value['timestamp'] as Timestamp).toDate();
        }
      });
      log('getFavouriteRecipes: $id $result');
      return result;
    } on Exception catch (e) {
      log('getFavouriteRecipes error', error: e);
      return {};
    }
  }

  // ------------------- user settings -------------------

  Future<void> addOrUpdateUserSettings({
    required String userId,
    required UserSettings userSettings,
  }) async {
    final id = 'P$userId';
    final map = userSettings.toJson();
    _userSettings.doc(id).set(map);
    log('addOrUpdateUserSettings: $id $map');
  }

  Future<UserSettings?> getUserSettings({
    required String userId,
  }) async {
    try {
      final id = 'P$userId';
      final document = await _userSettings.doc(id).get();
      final map = document.data();
      if (map == null) {
        return null;
      }
      final result = UserSettings.fromJson(map);
      log('getUserSettings: $id $result');
      return result;
    } on Exception catch (e) {
      log('getUserSettings error', error: e);
      return null;
    }
  }
}
