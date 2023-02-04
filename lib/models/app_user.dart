import 'package:firebase_auth/firebase_auth.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:platform_device_id/platform_device_id.dart';

part 'app_user.g.dart';

const unknownDevice = 'unknown_device';

@JsonSerializable(createToJson: true, constructor: '_')
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

  static Future<AppUser> create({User? googleUser}) async {
    final deviceId = await PlatformDeviceId.getDeviceId;
    return AppUser._(
      deviceId: deviceId ?? unknownDevice,
      uid: googleUser?.uid,
      displayName: googleUser?.displayName,
    );
  }

  factory AppUser.fromJson(Map<String, dynamic> json) => _$AppUserFromJson(json);

  Map<String, dynamic> toJson() => _$AppUserToJson(this);

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
