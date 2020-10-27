import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';

class StorageUtils {
  static final FirebaseStorage _storage = FirebaseStorage.instance;
  static Future<void> upload(String path, File file) async {
    await _storage.ref().child(path).putFile(file);
  }

  static Future<dynamic> getImage(String path) async {
    try {
      return await _storage.ref().child(path).getDownloadURL();
    } on PlatformException {
      throw PathNotFoundException();
    }
  }

  static Future<void> deleteImage(String path) async {
    try {
      await _storage.ref().child(path).delete();
    } on PlatformException {
      return;
    }
  }
}

class PathNotFoundException implements Exception {}
