import 'package:reni_jaya_inventory/models/item_model.dart';
import 'package:reni_jaya_inventory/services/database.dart';

class Category {
  String? categoryId;
  String name;
  List<Item>? items;

  Category({this.categoryId, required this.name, this.items});

  factory Category.fromDatabase(Map data) {
    List<Item> catItems = [];
    if (data[DatabaseService.fItems] != null) {
      data[DatabaseService.fItems].forEach((key, values) {
        catItems.add(Item.fromDatabase(values, key));
      });
    }
    return Category(
      categoryId: data[DatabaseService.fCategoryId],
      name: data[DatabaseService.fCategoryName] ?? "",
      items: catItems,
    );
  }
}
