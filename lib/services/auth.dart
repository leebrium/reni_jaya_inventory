import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:reni_jaya_inventory/models/response_model.dart';
import 'package:reni_jaya_inventory/shared/constants.dart';

class AuthService {
  final FirebaseAuth _auth;

  AuthService(this._auth);

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      return null;
    }
  }

  Future<Response> signInWithEmailandPassword(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return Response(errorMessage: "");
    } on PlatformException catch (e) {
      return Response(errorMessage: errorMessageFromFirebase(e.code));
    }
  }
}