import 'package:reni_jaya_inventory/services/database.dart';

class Item {
  String? itemId;
  String name;
  int quantity;
  String? imagePath;

  Item({this.itemId, required this.name, required this.quantity, this.imagePath});

  Item.fromDatabase(dynamic data) :
    itemId = data[DatabaseService.fItemId],
    name = data[DatabaseService.fItemName] ?? "",
    quantity = data[DatabaseService.fItemQuantity] ?? 0,
    imagePath =  data[DatabaseService.fItemImagePath];
}
