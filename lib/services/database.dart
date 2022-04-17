import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:reni_jaya_inventory/models/category_model.dart';
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
  static const fCategoryId = "category_id";
  static const fCategoryName = "category_name";
  static const fItems = "items";
  static const fItemId = "item_id";
  static const fItemName = "item_name";
  static const fItemQuantity = "quantity";
  static const fItemImagePath = "image_path";
  static const fItemDescription = "item_description";

  final _dbRef = FirebaseDatabase.instance.ref();

  DatabaseReference get _userDataRef {
    return _dbRef.child('user_data');
  }

  DatabaseReference _itemRef(String categoryId) {
    return _dbRef.child('categories/' + categoryId + '/items');
  }

  DatabaseReference get _categoryRef {
    return _dbRef.child('categories');
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

  Stream<DatabaseEvent> fetchCategoriesEvent(String id) {
    return _categoryRef.orderByKey().startAt(id).limitToFirst(10).onValue;
  }

  Stream<DatabaseEvent> searchCategoriesEvent(String query) {
    return _categoryRef
        .orderByChild(fCategoryName)
        .startAt(query)
        .endAt(query + "\uf8ff")
        .onValue;
  }

  // Insert or Update Categories
  Future<void> pushCategory(Category category) async {
    final bool isInsert = category.categoryId == null;
    final ref = isInsert ? _categoryRef.push() : _categoryRef.child(category.categoryId!);
    Map<String, Object?> data = {
      fCategoryName: category.name,
      fUpdatedAt: ServerValue.timestamp,
      fItems: category.items,
    };

    if (isInsert) {
      data[fCreatedAt] = ServerValue.timestamp;
    }

    return await ref.update(data);
  }

  Future<Category?> getCategoryDetails(String id) async {
    final snapshot = await _categoryRef.child(id).get();
    var data = snapshot.value as Map;
    data[fCategoryId] = id;

    return Category.fromDatabase(data);
  }

  /* Category <- */

  /* -> Item */

  Stream<DatabaseEvent> initialItemsEvent(String categoryId) {
    return _itemRef(categoryId).orderByKey().onValue;
  }
  
  Stream<DatabaseEvent> searchItemsEvent(String categoryId, String query) {
    return _itemRef(categoryId)
        .orderByChild(fItemName)
        .startAt(query)
        .endAt(query + "\uf8ff")
        .onValue;
  }

  Future<Item?> getItemDetails(String categoryId, String itemId) async {
    final snapshot = await _itemRef(categoryId).child(itemId).get();
    var data = snapshot.value as Map;
    data[fItemId] = itemId;

    return Item.fromDatabase(data);
  }

  // Insert or Update Item
  Future<void> pushItem(String categoryId, Item item) async {
    final bool isInsert = item.itemId == null;
    final ref = isInsert ? _itemRef(categoryId).push() : _itemRef(categoryId).child(item.itemId!);
    Map<String, Object?> data = {
      fItemName: item.name,
      fItemQuantity: item.quantity,
      fItemImagePath: item.imagePath,
      fItemDescription: item.description,
      fUpdatedAt: ServerValue.timestamp,
    };

    if (isInsert) {
      data[fCreatedAt] = ServerValue.timestamp;
    }

    return await ref.update(data);
  }

  /* Item <- */
}
