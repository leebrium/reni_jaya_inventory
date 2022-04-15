class UserData {
  String? uid;
  String? name;
  String? email;
  String? password;
  int? role; //0 = admin, 1 = user;

  bool get isAdmin {
    return role == 0;
  }

  UserData({this.uid, this.name, this.email, this.password, this.role});
}