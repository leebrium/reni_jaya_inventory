import 'package:flutter/material.dart';
import 'package:reni_jaya_inventory/models/user_data_model.dart';
import 'package:reni_jaya_inventory/services/database.dart';

class UserDataNotifier extends ChangeNotifier {
  UserData? _userData;

  UserData? get userData => _userData;

  UserDataNotifier(String uid) {
    _listenToUserData(uid);
  }

  Future<void> _listenToUserData(String uid) async {
    _userData = await DatabaseService().getUserData(uid);
    notifyListeners();
  }
}