import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reni_jaya_inventory/shared/button_submit.dart';

class ImageGetter extends StatelessWidget {
  const ImageGetter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool _hasChosen = false;

    _getImage(ImageSource source) async {
      if (_hasChosen) {
        return;
      }

      final XFile? _pickedFile = await ImagePicker().pickImage(source: source);

      if (_pickedFile != null) {
        _hasChosen = true;
        Navigator.pop(context, _pickedFile.path);
      }
    }

    return Container(
        child: Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          CustomButtonSubmit(
              height: 60,
              width: 200,
              text: 'GALLERY',
              onPressed: () async {
                _getImage(ImageSource.gallery);
              }),
          SizedBox(height: 40),
          CustomButtonSubmit(
            height: 60,
            width: 200,
            text: 'CAMERA',
            onPressed: () async {
              _getImage(ImageSource.camera);
            },
          ),
        ],
      ),
    ));
  }
}
