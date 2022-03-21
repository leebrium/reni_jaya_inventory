import 'package:flutter/material.dart';

class CustomButtonSubmit extends StatelessWidget {
  final VoidCallback onPressed;
  final double width;
  final double height;
  final String text;

  CustomButtonSubmit(
      {required this.onPressed,
      required this.width,
      required this.height,
      required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Container(
          constraints: BoxConstraints(minWidth: 88.0, minHeight: 36.0),
          alignment: Alignment.center,
          child: Text(
            text,
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
      ),
    );
  }
}
