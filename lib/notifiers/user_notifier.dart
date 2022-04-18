import 'package:flutter/material.dart';
import 'package:reni_jaya_inventory/models/user_data_model.dart';
import 'package:reni_jaya_inventory/services/database.dart';

enum UserRole {
  admin,
  staff,
}

class UserDataNotifier extends ChangeNotifier {
  UserData? _userData;
  String? uid;
  UserData? get userData => _userData;

  void setUserId(String uid) {
    this.uid = uid;
    _listenToUserData();
  }

  Future<void> _listenToUserData() async {
    _userData = await DatabaseService().getUserData(uid!);
  }
}