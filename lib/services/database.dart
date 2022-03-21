import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:reni_jaya_inventory/models/category_model.dart';
import 'package:reni_jaya_inventory/models/item_model.dart';
import 'package:reni_jaya_inventory/models/response_model.dart';
import 'package:reni_jaya_inventory/models/user_data_model.dart';
import 'package:reni_jaya_inventory/models/user_model.dart';
import 'package:reni_jaya_inventory/extensions/string.dart';

class DatabaseService {
  final _dbRef = FirebaseDatabase.instance.ref();

  DatabaseReference get _userDataRef {
    return _dbRef.child('user_data');
  }

  DatabaseReference get _itemRef {
    return _dbRef.child('items');
  }

  /* -> User Data */

  Future insertUserData(UserData userData) async {
    return await _userDataRef.child(userData.uid ?? '').setData({
      'name': userData.name,
      'email': userData.email,
      'type': userData.type,
      'created_at': ServerValue.timestamp,
    });
  }

  Future<UserData> getUserData(String uid) async {
    final snapshot = await _userDataRef.child(uid).get();
    final data = (snapshot.value) as Map<String, dynamic>;
    return UserData(
        uid: data['uid'],
        name: data['name'],
        email: data['email'],
        type: data['type']);
  }

  /* User Data  <- */

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
        .orderByChild("name")
        .startAt(query)
        .endAt(query + "\uf8ff")
        .onValue;
  }

  Future<Item?> getItemDetails(String id) async {
    final snapshot = await _itemRef.child(id).get();
    final data = snapshot.value as Map;

    return Item(
        itemId: id,
        name: data['name'],
        quantity: data['quantity'],
        imagePath: data['image_path']);
  }

  Future<void> updateItem(Item item) async {
    final ref = item.itemId == null ? _itemRef.push() : _itemRef.child(item.itemId!);
    return await ref.update({
      "name": item.name,
      "quantity": item.quantity,
      "image_path": item.imagePath,
      "created_at": ServerValue.timestamp,
      "updated_at": ServerValue.timestamp,
    });
  }

  /* Item <- */
}
