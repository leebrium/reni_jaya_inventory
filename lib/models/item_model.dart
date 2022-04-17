import 'package:reni_jaya_inventory/services/database.dart';

class Item {
  String? itemId;
  String name;
  int quantity;
  String? imagePath;
  String? description;

  Item(
      {this.itemId,
      required this.name,
      required this.quantity,
      this.imagePath,
      this.description});

  factory Item.fromDatabase(Map data, [String? id]) {
    return Item(
      itemId: data[DatabaseService.fItemId] ?? id,
      name: data[DatabaseService.fItemName],
      quantity: data[DatabaseService.fItemQuantity],
      imagePath: data[DatabaseService.fItemImagePath],
      description: data[DatabaseService.fItemDescription] ?? "",
    );
  }
}
