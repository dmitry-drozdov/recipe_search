import 'package:firebase_auth/firebase_auth.dart';

extension UserExtension on User {
  Map<String, dynamic> get marshal {
    return {
      'uid': uid,
      'displayName': displayName,
      'email': email,
      'phoneNumber': phoneNumber,
    };
  }
}
