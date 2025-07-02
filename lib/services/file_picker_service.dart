import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';

class PickedFileResult {
  final String fileName;
  final PlatformFile platformFile;
  final File? file;

  PickedFileResult({
    required this.fileName,
    required this.platformFile,
    this.file,
  });
}

class FilePickerService {
  /// Pick a PDF file
  Future<PickedFileResult?> pickPdfFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      withData: true,
    );

    if (result != null && result.files.isNotEmpty) {
      final file = result.files.first;
      return PickedFileResult(
        fileName: file.name,
        platformFile: file,
        file: kIsWeb ? null : File(file.path!),
      );
    }
    return null;
  }

  /// Pick a Video file
  Future<PickedFileResult?> pickVideoFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.video,
      withData: true,
    );

    if (result != null && result.files.isNotEmpty) {
      final file = result.files.first;
      return PickedFileResult(
        fileName: file.name,
        platformFile: file,
        file: kIsWeb ? null : File(file.path!),
      );
    }
    return null;
  }
}
