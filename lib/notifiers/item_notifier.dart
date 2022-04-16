import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:reni_jaya_inventory/models/item_model.dart';
import 'package:reni_jaya_inventory/services/database.dart';

class ItemNotifier extends ChangeNotifier {
  List<Item> _items = [];
  String? _currentId;
  List<Item> get items => _items;
  String _categoryId = "";

  final _dbService = DatabaseService();
  
  void setId(String id) {
    _items.clear();
    _categoryId = id;
    _fetchInitialItems();
  }

  void _fetchInitialItems() {
    _dbService.initialItemsEvent(_categoryId).listen((event) {
      _items.clear();
      _addItemsFromEvent(event);
    });
  }

  void _addItemsFromEvent(DatabaseEvent event) {
    final data = event.snapshot.value as Map;
    data.forEach((key, value) {
      data[key][DatabaseService.fItemId] = key;
      _items.add(Item.fromDatabase(data[key]));
    });
    _currentId = items.last.itemId;
    notifyListeners();
  }

  void searchItems(String query) {
    _dbService.searchItemsEvent(_categoryId, query).listen((event) {
      _items.clear();
      _addItemsFromEvent(event);
    });
  }

  Future<Item?> getItemDetails(String id) {
    return _dbService.getItemDetails(_categoryId, id);
  }

  Future<void> pushItem(Item item) async {
    return await _dbService.pushItem(_categoryId, item);
  }
}
