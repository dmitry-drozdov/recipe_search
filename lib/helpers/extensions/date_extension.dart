extension ListExtension on DateTime {
  // returns 20220722T193356
  String get customIso861 {
    return toIso8601String().replaceAll(RegExp(r'[-:]'), "").split('.')[0];
  }
}
