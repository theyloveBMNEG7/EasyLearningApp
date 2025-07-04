import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../../data/models/correction_model.dart';
import '../../../../../services/file_picker_service.dart';
import '../../../../../services/firebase_storage_service.dart';
import 'upload_common_widgets.dart';

class UploadCorrectionTab extends StatefulWidget {
  const UploadCorrectionTab({super.key});

  @override
  State<UploadCorrectionTab> createState() => _UploadCorrectionTabState();
}

class _UploadCorrectionTabState extends State<UploadCorrectionTab> {
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _description = TextEditingController();
  final _subject = TextEditingController();
  String? _selectedLevel;

  PickedFileResult? _pickedFile;
  bool _isUploading = false;

  final _pickerService = FilePickerService();
  final _storageService = FirebaseStorageService();

  Future<void> _pickFile() async {
    final file = await _pickerService.pickPdfFile();
    if (file != null) {
      setState(() => _pickedFile = file);
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    if (_pickedFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a PDF file to upload.')),
      );
      return;
    }

    setState(() => _isUploading = true);

    try {
      final teacherId = FirebaseAuth.instance.currentUser?.uid;
      if (teacherId == null) throw Exception('Not authenticated');

      final pdfUrl = await _storageService.uploadFile(
        platformFile: _pickedFile!.platformFile,
        folder: 'reviewed_questions',
      );

      final correction = CorrectionModel(
        id: '',
        title: _title.text.trim(),
        description: _description.text.trim(),
        subject: _subject.text.trim(),
        level: _selectedLevel!,
        pdfUrl: pdfUrl,
        teacherId: teacherId,
        createdAt: DateTime.now(),
      );

      await FirebaseFirestore.instance
          .collection('reviewed_questions')
          .add(correction.toMap());

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Correction uploaded successfully!')),
      );

      _title.clear();
      _description.clear();
      _subject.clear();
      setState(() {
        _selectedLevel = null;
        _pickedFile = null;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ Upload failed: $e')),
      );
    } finally {
      setState(() => _isUploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: buildForm(
            icon: FontAwesomeIcons.filePdf,
            label: "Correction",
            formContent: [
              buildTextField(_title, 'Title', Icons.title),
              buildTextField(_description, 'Description', Icons.description,
                  maxLines: 3),
              buildTextField(_subject, 'Subject', Icons.subject),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: DropdownButtonFormField<String>(
                  value: _selectedLevel,
                  items: ["Year 1", "Year 2"]
                      .map((lvl) =>
                          DropdownMenuItem(value: lvl, child: Text(lvl)))
                      .toList(),
                  onChanged: (val) => setState(() => _selectedLevel = val),
                  decoration: const InputDecoration(
                    labelText: 'Level',
                    prefixIcon: Icon(Icons.school),
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => v == null ? 'Please select a level' : null,
                ),
              ),
              buildFilePicker(
                _pickedFile == null
                    ? "Upload Correction PDF"
                    : "Selected: ${_pickedFile!.fileName}",
                Icons.upload_file,
                _pickFile,
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _isUploading ? null : _submitForm,
                icon: _isUploading
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.cloud_upload),
                label: Text(_isUploading ? "Uploading..." : "Submit"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isUploading ? Colors.grey : Colors.green,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
