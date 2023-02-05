import 'package:internet_connection_checker/internet_connection_checker.dart';

extension InternetStatusExtension on InternetConnectionStatus {
  bool get connected => this == InternetConnectionStatus.connected;
  bool get disconnected => this == InternetConnectionStatus.disconnected;
}
