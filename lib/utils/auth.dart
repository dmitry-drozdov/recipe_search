import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:localstorage/localstorage.dart';
import 'package:recipe_search/utils/firestore.dart';

import '../main.dart';
import '../models/app_user.dart';

final userKey = 'user'.hashCode.toString();

class Authentication {
  final fbStorage = locator<FirebaseStorage>();
  final storage = LocalStorage('auth');
  final FirebaseApp? firebaseApp;

  Authentication(this.firebaseApp);

  Future<void> rememberAppUser(AppUser user) async {
    await storage.setItem(userKey, user);
  }

  Future<AppUser?> getLastKnownAppUser() async {
    final Map<String, dynamic>? json = await storage.getItem(userKey);
    if (json != null) {
      return AppUser.fromJson(json);
    }
    return null;
  }

  Future<User?> signInWithGoogle() async {
    final auth = FirebaseAuth.instance;
    User? user;

    final googleSignIn = GoogleSignIn();

    final googleSignInAccount = await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      final googleSignInAuthentication = await googleSignInAccount.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      try {
        final userCredential = await auth.signInWithCredential(credential);

        user = userCredential.user;
      } catch (e) {
        log('signInWithCredential error', error: e);
      }
    }

    if (user != null) {
      fbStorage.logUserSession(user, DateTime.now());
    }

    return user;
  }

  Future<void> signOut() async {
    final googleSignIn = GoogleSignIn();

    try {
      await googleSignIn.signOut();
    } catch (e) {
      log('googleSignIn.signOut error', error: e);
    }

    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      log('FirebaseAuth.signOut error', error: e);
    }
  }
}
