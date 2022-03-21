import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:reni_jaya_inventory/models/item_model.dart';
import 'package:reni_jaya_inventory/models/user_data_model.dart';
import 'package:reni_jaya_inventory/services/database.dart';

class ItemNotifier extends ChangeNotifier {
  List<Item> _items = [];
  String? _currentId;
  List<Item> get items => _items;

  final _dbService = DatabaseService();

  ItemNotifier() {
    _fetchInitialItems();
  }

  void _fetchInitialItems() {
    _dbService.initialItemsEvent().listen((event) {
      _items.clear();
      _addItemsFromEvent(event);
    });
  }

  void _fetchInitialItemsWithLimit() {
    _dbService.initialItemsEventWithLimit().listen((event) {
      _addItemsFromEvent(event);
    });
  }

  void _addItemsFromEvent(DatabaseEvent event) {
    final data = event.snapshot.value as Map;
    data.forEach((key, value) {
      _items.add(
          Item(itemId: key, name: value['name'], quantity: value['quantity']));
    });
    _currentId = items.last.itemId;
    notifyListeners();
  }

  void fetchItems() {
    _dbService.fetchItemsEvent(_currentId!).listen((event) {
      _addItemsFromEvent(event);
    });
  }

  void searchItems(String query) {
    _dbService.searchItemsEvent(query).listen((event) {
      _items.clear();
      _addItemsFromEvent(event);
    });
  }

  Future<Item?> getItemDetails(String id) {
    return _dbService.getItemDetails(id);
  }

  Future<void> insertNewItem(Item item) async {
    return await _dbService.updateItem(item);
  }
}
