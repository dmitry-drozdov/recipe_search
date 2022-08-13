import 'package:intl/intl.dart';

extension DateExtension on DateTime {
  // returns 20220722T193356
  String get customIso861 {
    return toIso8601String().replaceAll(RegExp(r'[-:]'), "").split('.')[0];
  }

  String get human {
    final now = DateTime.now();
    if (now.day == day) {
      return 'Today, ${DateFormat('hh:mm aa').format(this)}';
    }
    if (now.day - 1 == day) {
      return 'Yesterday, ${DateFormat('hh:mm aa').format(this)}';
    }
    return DateFormat('MMM d, yyyy @ hh:mm aa').format(this);
  }
}
