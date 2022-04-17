import 'package:flutter/material.dart';

const textInputDecoration = InputDecoration(
  isDense: true,
  contentPadding: EdgeInsets.only(bottom: 5, top: 10),
  labelStyle: TextStyle(
    color: Colors.blue,
    fontSize: 20,
  ),
  hintStyle: TextStyle(fontSize: 14),
  floatingLabelBehavior: FloatingLabelBehavior.always,
);

const textInputStyle = TextStyle(
  fontSize: 22,
);

const textHeaderStyle = TextStyle(
  color: Colors.black,
  fontSize: 16,
  fontWeight: FontWeight.bold,
);

String errorMessageFromFirebase(String code) {
  String msg = "";
  switch (code) {
    case "ERROR_WRONG_PASSWORD":
      msg = "Invalid email or password";
      break;
    case "ERROR_INVALID_EMAIL":
      msg = "Invalid email or password";
      break;
    case "ERROR_USER_NOT_FOUND":
      msg = "There is no user record registered with this email";
      break;
    default:
  }

  return msg;
}

List<Color> kitGradients = [
  Colors.blue,
  Colors.blue.shade300,
];
