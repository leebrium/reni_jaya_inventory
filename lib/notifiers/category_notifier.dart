import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:reni_jaya_inventory/models/category_model.dart';
import 'package:reni_jaya_inventory/services/database.dart';

class CategoryNotifier extends ChangeNotifier {
  List<Category> _categories = [];
  String? _currentId;
  List<Category> get categories => _categories;

  final _dbService = DatabaseService();

  CategoryNotifier() {
    _fetchInitialCategories();
  }

  void _fetchInitialCategories() {
    _dbService.initialCategoryEvent().listen((event) {
      _categories.clear();
      _addCategoriesFromEvent(event);
    });
  }

  void _addCategoriesFromEvent(DatabaseEvent event) {
    final data = event.snapshot.value as Map;
    data.forEach((key, value) {
      data[key][DatabaseService.fCategoryId] = key;
      _categories.add(Category.fromDatabase(data[key]));
    });
    _currentId = categories.last.categoryId;
    notifyListeners();
  }

  void searchCategories(String query) {
    _dbService.searchCategoriesEvent(query).listen((event) {
      _categories.clear();
      _addCategoriesFromEvent(event);
    });
  }

  Future<Category?> getCategoryDetails(String id) {
    return _dbService.getCategoryDetails(id);
  }

  Future<void> pushCategory(Category cat) async {
    return await _dbService.pushCategory(cat);
  }
}
