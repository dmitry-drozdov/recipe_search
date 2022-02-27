const recipeKey = 'recipeKey';

// ignore: avoid_classes_with_only_static_members
class ViewModelProvider {
  static final _map = <String, dynamic>{};

  static T get<T>(String key) {
    if (_map.containsKey(key)) {
      return _map[key];
    }
    throw Exception('view model for key "$key" not found');
  }

  static T getIfExists<T>(String key) {
    return _map[key];
  }

  static T getOrCreate<T>({required String key, required T Function() create}) {
    _map.putIfAbsent(key, () => create.call());
    return _map[key];
  }

  static void delete(String key) {
    _map.remove(key);
  }

  static void clear() {
    _map.clear();
  }
}
