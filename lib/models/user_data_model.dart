import 'package:reni_jaya_inventory/notifiers/user_notifier.dart';

class UserData {
  String? uid;
  String? name;
  String? email;
  String? password;
  UserRole? role;

  bool get isAdmin {
    return role == UserRole.admin;
  }

  UserData({this.uid, this.name, this.email, this.password, this.role});
}