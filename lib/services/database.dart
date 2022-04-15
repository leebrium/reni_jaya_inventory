import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:reni_jaya_inventory/models/item_model.dart';
import 'package:reni_jaya_inventory/models/user_data_model.dart';
import 'package:reni_jaya_inventory/extensions/string.dart';

class DatabaseService {

  static const fCreatedAt = "created_at";
  static const fUpdatedAt = "updated_at";
  static const fUserId = "uid";
  static const fName = "name";
  static const fEmail = "email";
  static const fUserRole = "role";
  static const fItemId = "item_id";
  static const fItemName = "item_name";
  static const fItemQuantity = "quantity";
  static const fItemImagePath = "image_path";

  final _dbRef = FirebaseDatabase.instance.ref();

  DatabaseReference get _userDataRef {
    return _dbRef.child('user_data');
  }

  DatabaseReference get _itemRef {
    return _dbRef.child('items');
  }

  DatabaseReference get _categoryRef {
    return _categoryRef.child('category');
  }

  /* -> User Data */

  Future insertUserData(UserData userData) async {
    return await _userDataRef.child(userData.uid ?? '').setData({
      fName: userData.name,
      fEmail: userData.email,
      fUserRole: userData.role,
      fCreatedAt: ServerValue.timestamp,
    });
  }

  Future<UserData> getUserData(String uid) async {
    final snapshot = await _userDataRef.child(uid).get();
    final data = (snapshot.value) as Map<String, dynamic>;
    return UserData(
        uid: data[fUserId],
        name: data[fName],
        email: data[fEmail],
        role: data[fUserRole]);
  }

  /* User Data  <- */

  /* -> Category */

  Stream<DatabaseEvent> initialCategoryEvent() {
    return _categoryRef.orderByKey().onValue;
  }

  /* Category <- */

  /* -> Item */

  Stream<DatabaseEvent> initialItemsEvent() {
    return _itemRef.orderByKey().onValue;
  }

  Stream<DatabaseEvent> initialItemsEventWithLimit() {
    return _itemRef.limitToFirst(10).onValue;
  }

  Stream<DatabaseEvent> fetchItemsEvent(String id) {
    return _itemRef.orderByKey().startAt(id).limitToFirst(10).onValue;
  }

  Stream<DatabaseEvent> searchItemsEvent(String query) {
    return _itemRef
        .orderByChild(fName)
        .startAt(query)
        .endAt(query + "\uf8ff")
        .onValue;
  }

  Future<Item?> getItemDetails(String id) async {
    final snapshot = await _itemRef.child(id).get();
    var data = snapshot.value as Map;
    data[fItemId] = id;

    return Item.fromDatabase(data);
  }

  // Insert or Update Item
  Future<void> pushItem(Item item) async {
    final bool isInsert = item.itemId == null;
    final ref = isInsert ? _itemRef.push() : _itemRef.child(item.itemId!);
    Map<String, Object?> data = {
      fItemName: item.name,
      fItemQuantity: item.quantity,
      fItemImagePath: item.imagePath,
      fUpdatedAt: ServerValue.timestamp,
    };

    if (isInsert) {
      data[fCreatedAt] = ServerValue.timestamp;
    }

    return await ref.update(data);
  }

  /* Item <- */
}
