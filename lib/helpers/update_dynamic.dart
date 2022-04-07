dynamic update(dynamic oldValue, dynamic newValue) {
  dynamic _value;
  if (newValue != null) {
    _value = newValue;
  } else if (oldValue != null) {
    _value = oldValue;
  }
  return _value;
}
