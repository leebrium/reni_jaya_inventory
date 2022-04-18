import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:reni_jaya_inventory/models/response_model.dart';
import 'package:reni_jaya_inventory/services/auth.dart';
import 'package:reni_jaya_inventory/shared/animated_background.dart';
import 'package:reni_jaya_inventory/shared/button_submit.dart';
import 'package:reni_jaya_inventory/shared/constants.dart';
import 'package:reni_jaya_inventory/shared/loading.dart';
import 'package:reni_jaya_inventory/extensions/string.dart';

class SignInView extends StatefulWidget {
  const SignInView({Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignInView> {
  final AuthService _authService = AuthService(FirebaseAuth.instance);
  final _formKey = GlobalKey<FormState>();

  bool loading = false;
  String email = '';
  String password = '';
  String error = '';

  void _onLoginPressed() async {
    if (_formKey.currentState!.validate()) {
      setState(() => loading = true);

      try {
        Response result =
            await _authService.signInWithEmailandPassword(email, password);
        if (!result.success) {
          setState(() {
            loading = false;
            error = result.errorMessage;
          });
        }
      } catch (e) {
        setState(() {
          loading = false;
          error = "Gagal Login";
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Loading()
        : Scaffold(
            resizeToAvoidBottomInset: false,
            body: GestureDetector(
              onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
              child: Stack(
                children: <Widget>[
                  FancyBackground(),
                  Positioned(
                    left: 12,
                    right: 12,
                    top: 220,
                    bottom: 50,
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 4,
                            )
                          ]),
                      child: Form(
                        key: _formKey,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 25, right: 25),
                          child: Column(
                            children: <Widget>[
                              const SizedBox(height: 60),
                              const Text(
                                'LOGIN',
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 40),
                              TextFormField(
                                validator: (val) {
                                  if (val!.isEmpty) {
                                    return "Masukkan Email";
                                  } else if (!val.isValidEmail()) {
                                    return "Masukkan format email yang benar";
                                  } else {
                                    return null;
                                  }
                                },
                                onChanged: (val) {
                                  setState(() {
                                    email = val;
                                  });
                                },
                                style: textInputStyle,
                                decoration: textInputDecoration.copyWith(
                                    labelText: "Email"),
                              ),
                              const SizedBox(height: 30),
                              TextFormField(
                                validator: (val) => val!.length < 3
                                    ? "Masukkan Password min. 3 karakter"
                                    : null,
                                onChanged: (val) {
                                  setState(() {
                                    password = val;
                                  });
                                },
                                decoration: textInputDecoration.copyWith(
                                    labelText: "Password"),
                                style: textInputStyle,
                                obscureText: true,
                              ),
                              const SizedBox(height: 50),
                              CustomButtonSubmit(
                                height: 60,
                                width: 200,
                                text: 'LOGIN',
                                onPressed: _onLoginPressed,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                error,
                                style: const TextStyle(
                                    color: Colors.red, fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
  }
}
