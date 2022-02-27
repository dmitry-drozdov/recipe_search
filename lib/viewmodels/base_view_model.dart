import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

// T - items
// E - events for UI
abstract class BaseViewModel<T, E> extends ChangeNotifier {
  final processingIds = <String>[];
  final expandedIds = <String>[];

  BaseViewModel();

  // Listen events for UI
  final uiEventSubject = PublishSubject<E>();
  final _uiEventSubscription = CompositeSubscription();

  StreamSubscription startUIListening(Function(E) listener) =>
      _uiEventSubscription.add(uiEventSubject.listen(listener));

  void stopUIListening() => _uiEventSubscription.clear();

  void removeUIListeners(StreamSubscription subscription) {
    subscription.cancel();
    _uiEventSubscription.remove(subscription);
  }

  // Loading
  bool loading = false;

  @protected
  void setLoading({required bool value, bool notify = true}) {
    loading = value;
    if (notify) {
      notifyListeners();
    }
  }

  @protected
  Future<void> waitingLoading({int duration = 200}) async {
    if (loading) {
      await Future.doWhile(() => Future.delayed(Duration(milliseconds: duration), () => loading));
    }
  }

  // Items
  List<T> items = <T>[];

  int get count => items.length;

  // Without notifying
  @protected
  void silenceClearItems() => items.clear();

  @protected
  void silenceAdd(T item) => items.add(item);

  @protected
  void silenceAddRange(Iterable<T> iterable) => items.addAll(iterable);

  @protected
  void silenceInsert(T item, {int index = 0}) => items.insert(index, item);

  @protected
  void silenceInsertRange(Iterable<T> iterable, {int index = 0}) => items.insertAll(index, iterable);

  @protected
  void silenceReplace(T item, {int index = 0}) => items.replaceRange(index, index + 1, [item]);

  @protected
  void silenceRemove(T item) => items.remove(item);

  @protected
  void silenceRemoveWhere(bool Function(T) test) => items.removeWhere(test);

  @protected
  void silenceRemoveToEnd(int fromIndex) => items.removeRange(fromIndex, items.length);

  // Claim notifying
  @protected
  void clearItems() {
    silenceClearItems();
    notifyListeners();
  }

  @protected
  void add(T item) {
    silenceAdd(item);
    notifyListeners();
  }

  @protected
  void addRange(Iterable<T> iterable) {
    silenceAddRange(iterable);
    notifyListeners();
  }

  @protected
  void insert(T item, {int index = 0}) {
    silenceInsert(item, index: index);
    notifyListeners();
  }

  @protected
  void insertRange(Iterable<T> iterable, {int index = 0}) {
    silenceInsertRange(iterable, index: index);
    notifyListeners();
  }

  @protected
  void replace(T item, {int index = 0}) {
    silenceReplace(item, index: index);
    notifyListeners();
  }

  @protected
  void remove(T item) {
    silenceRemove(item);
    notifyListeners();
  }

  @protected
  void removeWhere(bool Function(T) test) {
    silenceRemoveWhere(test);
    notifyListeners();
  }

  @protected
  void removeToEnd(int fromIndex) {
    silenceRemoveToEnd(fromIndex);
    notifyListeners();
  }

  T get(int index) => index < items.length ? items[index] : throw Exception('Item $index not found.');

  T singleWhere(bool Function(T) condition, {required T Function() orElse}) =>
      items.singleWhere(condition, orElse: orElse);

  int indexWhere(bool Function(T) condition) => items.indexWhere(condition);

  void sort({required int Function(T, T) compare}) => items.sort(compare);
}
