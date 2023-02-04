import 'package:firebase_auth/firebase_auth.dart';
import 'package:platform_device_id/platform_device_id.dart';

const unknownDevice = 'unknown_device';

class AppUser {
  final String deviceId;

  // google auth params:
  final String? uid;
  final String? displayName;

  AppUser._({
    required this.deviceId,
    this.uid,
    this.displayName,
  });

  static Future<AppUser> create(User? googleUser) async {
    final deviceId = await PlatformDeviceId.getDeviceId;
    return AppUser._(
      deviceId: deviceId ?? unknownDevice,
      uid: googleUser?.uid,
      displayName: googleUser?.displayName,
    );
  }

  String get title {
    if (displayName?.isNotEmpty == true) {
      return " — $displayName";
    }
    return " — guest";
  }

  String get userId {
    if (googleAuth) {
      return uid!;
    }
    if (deviceId.isNotEmpty) {
      return deviceId;
    }
    return unknownDevice;
  }

  bool get googleAuth => uid?.isNotEmpty == true;
}
