import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:reni_jaya_inventory/shared/constants.dart';

Future<Uint8List> getBytesFromAsset(String path, int width) async {
  ByteData data = await rootBundle.load(path);
  ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
      targetWidth: width);
  ui.FrameInfo fi = await codec.getNextFrame();
  return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
      .buffer
      .asUint8List();
}

Widget getTitleAndContent(String header, String content) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        header,
        style: textHeaderStyle,
      ),
      const SizedBox(height: 4),
      Text(
        content,
        style: const TextStyle(fontSize: 13),
      ),
    ],
  );
}

Widget getEmptyViewWithMessage(String text) {
  return Center(
    child: Text(
      text,
      style: const TextStyle(
        color: Colors.grey,
        fontSize: 13,
      ),
    ),
  );
}
