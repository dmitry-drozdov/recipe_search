extension DoubleEx on double {
  double toPrecision(int n) => double.parse(toStringAsFixed(n));

  String trimZero() {
    final regex = RegExp(r'([.]*0)(?!.*\d)');
    return toString().replaceAll(regex, '');
  }
}
