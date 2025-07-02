import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:file_picker/file_picker.dart';

class FirebaseStorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> uploadFile({
    required PlatformFile platformFile,
    required String folder,
  }) async {
    try {
      final ref = _storage.ref().child('$folder/${platformFile.name}');
      UploadTask uploadTask;

      if (kIsWeb) {
        uploadTask = ref.putData(
            platformFile.bytes!, SettableMetadata(contentType: 'video/mp4'));
      } else {
        uploadTask = ref.putFile(File(platformFile.path!));
      }

      final snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      throw Exception("Upload failed: $e");
    }
  }
}
