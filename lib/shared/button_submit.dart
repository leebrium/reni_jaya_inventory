import 'package:flutter/material.dart';

class CustomButtonSubmit extends StatelessWidget {
  final VoidCallback onPressed;
  final double width;
  final double height;
  final String text;

  const CustomButtonSubmit(
      {Key? key,
      required this.onPressed,
      required this.width,
      required this.height,
      required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Container(
          constraints: const BoxConstraints(minWidth: 88.0, minHeight: 36.0),
          alignment: Alignment.center,
          child: Text(
            text,
            style: const TextStyle(color: Colors.white, fontSize: 20),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
