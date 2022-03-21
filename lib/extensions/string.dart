import 'package:firebase_database/firebase_database.dart';
import 'package:reni_jaya_inventory/models/response_model.dart';

extension Validator on String {
  bool isValidEmail () {
    return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(this);
  }

  bool isValidPhone () {
    return this.isNotEmpty && (this.length > 10 && this.length < 15) && RegExp(r"^[0-9]+$").hasMatch(this);
  }
}

extension DBReference on DatabaseReference {
  Future<Response> setData(Map data) async {
    return await set({data})
    .then((value) => Response(errorMessage: ""))
    .catchError((error) => Response(errorMessage: error.toString()));
  }
}