import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:recipe_search/helpers/extensions/date_extension.dart';
import 'package:recipe_search/helpers/extensions/user_extension.dart';

class Storage {
  static final CollectionReference userSessions = FirebaseFirestore.instance.collection('userSessions');

  static Future<void> createUserSession(User user, DateTime timestamp) async {
    final id = '${timestamp.customIso861}${user.email}';
    await userSessions.doc(id).set({
      'user': user.marshal,
      'timestamp': timestamp,
    });
  }
}
