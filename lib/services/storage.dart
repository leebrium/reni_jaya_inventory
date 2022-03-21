import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

class StorageService {
  Future<StorageServiceResult?> uploadImage({
    required File imageToUpload,
    required String title,
  }) async {
    var folderName = "reni-jaya-inventory/items/image/";
    var imageFileName =
        title + DateTime.now().millisecondsSinceEpoch.toString();
    final Reference firebaseStorageRef =
        FirebaseStorage.instance.ref().child(folderName + imageFileName);
    TaskSnapshot snapshot = await firebaseStorageRef.putFile(imageToUpload);

    var downloadUrl = await snapshot.ref.getDownloadURL();

    if (snapshot.state == TaskState.success) {
      var url = downloadUrl.toString();
      return StorageServiceResult(
        imageUrl: url,
        imageFileName: imageFileName,
      );
    }
    return null;
  }

  Future deleteImage(String imageFileName) async {
    final Reference firebaseStorageRef =
        FirebaseStorage.instance.ref().child(imageFileName);
    try {
      await firebaseStorageRef.delete();
      return true;
    } catch (e) {
      return e.toString();
    }
  }
}

class StorageServiceResult {
  final String imageUrl;
  final String imageFileName;

  bool get success {
    return imageUrl != null && imageUrl.isNotEmpty;
  }  
  StorageServiceResult({required this.imageUrl, required this.imageFileName});
}
