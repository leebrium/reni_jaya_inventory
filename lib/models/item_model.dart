import 'package:reni_jaya_inventory/services/database.dart';

class Item {
  String? itemId;
  String name;
  int quantity;
  String? imagePath;

  Item(
      {this.itemId,
      required this.name,
      required this.quantity,
      this.imagePath});

  factory Item.fromDatabase(Map data, [String? id]) {
    return Item(
      itemId: data[DatabaseService.fItemId] ?? id,
      name: data[DatabaseService.fItemName],
      quantity: data[DatabaseService.fItemQuantity],
      imagePath: data[DatabaseService.fItemImagePath],
    );
  }
}
