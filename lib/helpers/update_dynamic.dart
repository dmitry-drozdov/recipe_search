dynamic update(dynamic oldValue, dynamic newValue) {
  dynamic val;
  if (newValue != null) {
    val = newValue;
  } else if (oldValue != null) {
    val = oldValue;
  }
  return val;
}
