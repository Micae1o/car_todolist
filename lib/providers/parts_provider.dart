import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

import '../models/part_item.dart';

class PartsProvider extends ChangeNotifier {
  final Box<PartItem> _box;
  late final StreamSubscription _subscription;

  List<PartItem> _items = [];
  String _query = '';
  PartCategory? _categoryFilter;

  PartsProvider(this._box) {
    _items = _box.values.toList();
    _subscription = _box.watch().listen((_) {
      _items = _box.values.toList();
      notifyListeners();
    });
  }

  List<PartItem> get items => List.unmodifiable(_items);

  String get query => _query;
  PartCategory? get categoryFilter => _categoryFilter;

  List<PartItem> get filteredItems {
    Iterable<PartItem> it = _items;
    if (_query.isNotEmpty) {
      final q = _query.toLowerCase();
      it = it.where((e) => e.name.toLowerCase().contains(q));
    }
    if (_categoryFilter != null) {
      it = it.where((e) => e.category == _categoryFilter);
    }
    final list = it.toList();
    list.sort((a, b) {
      if (a.purchased == b.purchased) {
        return a.name.toLowerCase().compareTo(b.name.toLowerCase());
      }
      return a.purchased ? 1 : -1;
    });
    return list;
  }

  void setQuery(String value) {
    _query = value;
    notifyListeners();
  }

  void setCategory(PartCategory? category) {
    _categoryFilter = category;
    notifyListeners();
  }

  Future<void> addOrUpdate(PartItem item) async {
    if (item.isInBox) {
      await item.save();
    } else {
      await _box.add(item);
    }
  }

  Future<void> remove(PartItem item) async {
    await item.delete();
  }

  Future<void> togglePurchased(PartItem item) async {
    item.purchased = !item.purchased;
    await item.save();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
