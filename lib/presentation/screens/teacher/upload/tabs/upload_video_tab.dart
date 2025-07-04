import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../../data/models/tutorial_model.dart';
import '../../../../../services/firebase_storage_service.dart';
import '../../../../../services/file_picker_service.dart';
import 'upload_common_widgets.dart';

class UploadVideoTab extends StatefulWidget {
  const UploadVideoTab({super.key});

  @override
  State<UploadVideoTab> createState() => _UploadVideoTabState();
}

class _UploadVideoTabState extends State<UploadVideoTab> {
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _description = TextEditingController();
  final _subject = TextEditingController();
  String? _selectedLevel;

  PickedFileResult? _pickedFile;
  bool _isUploading = false;

  final _storageService = FirebaseStorageService();
  final _pickerService = FilePickerService();

  Future<void> _pickFile() async {
    final file = await _pickerService.pickVideoFile();
    if (file != null) {
      setState(() => _pickedFile = file);
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    if (_pickedFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a video file to upload.')),
      );
      return;
    }

    setState(() => _isUploading = true);

    try {
      final teacherId = FirebaseAuth.instance.currentUser?.uid;
      if (teacherId == null) throw Exception('Not authenticated');

      final videoUrl = await _storageService.uploadFile(
        platformFile: _pickedFile!.platformFile,
        folder: 'tutorials',
      );

      final tutorial = TutorialModel(
        id: '',
        title: _title.text.trim(),
        description: _description.text.trim(),
        subject: _subject.text.trim(),
        level: _selectedLevel!,
        videoUrl: videoUrl,
        teacherId: teacherId,
        createdAt: DateTime.now(),
      );

      await FirebaseFirestore.instance
          .collection('tutorials')
          .add(tutorial.toMap());

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('✅ Tutorial video uploaded successfully!')),
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
            icon: FontAwesomeIcons.video,
            label: "Tutorial",
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
                    ? "Upload Tutorial Video"
                    : "Selected: ${_pickedFile!.fileName}",
                Icons.video_call,
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
