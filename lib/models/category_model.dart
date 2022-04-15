import 'package:reni_jaya_inventory/models/item_model.dart';

class Category {
  String categoryId = "";
  String name = "";
  List<Item> items = [];

  Category({required this.categoryId, required this.name, required this.items});
}