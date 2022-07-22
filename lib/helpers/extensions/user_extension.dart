import 'package:firebase_auth/firebase_auth.dart';

extension ListExtension on User {
  Map<String, dynamic> get marshal {
    return {
      'uid': uid,
      'displayName': displayName,
      'email': email,
      'phoneNumber': phoneNumber,
    };
  }
}
