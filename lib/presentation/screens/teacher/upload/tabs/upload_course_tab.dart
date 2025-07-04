import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';

import '../../../../../data/models/book_model.dart';
import '../../../../../services/book_service.dart';
import 'upload_common_widgets.dart'; // Shared UI components

class UploadCourseTab extends StatefulWidget {
  final String? teacherId;

  const UploadCourseTab({super.key, this.teacherId});

  @override
  State<UploadCourseTab> createState() => _UploadCourseTabState();
}

class _UploadCourseTabState extends State<UploadCourseTab> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  String? _selectedLevel;
  File? _selectedFile;
  bool _isUploading = false;

  final List<String> levels = ['HND 1', 'HND 2', 'BTS 1', 'BTS 2'];

  Future<void> _pickFile() async {
    final result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
    if (result != null && result.files.single.path != null) {
      setState(() {
        _selectedFile = File(result.files.single.path!);
      });
    }
  }

  Future<void> _uploadCourse() async {
    if (!_formKey.currentState!.validate() ||
        _selectedLevel == null ||
        _selectedFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('⚠️ Please complete all fields.')),
      );
      return;
    }

    setState(() => _isUploading = true);

    try {
      // Upload PDF and get URL
      final pdfUrl = await BookService.uploadPdf(_selectedFile!);

      // Prepare course data
      final courseData = {
        'title': _titleController.text.trim(),
        'description': _descriptionController.text.trim(),
        'level': _selectedLevel,
        'pdfUrl': pdfUrl,
        'teacherId': widget.teacherId,
        'createdAt': DateTime.now().toIso8601String(),
      };

      // Save to Firestore
      await FirebaseFirestore.instance.collection('courses').add(courseData);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Course uploaded successfully!')),
      );

      // Reset form
      _titleController.clear();
      _descriptionController.clear();
      setState(() {
        _selectedLevel = null;
        _selectedFile = null;
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Course Material'),
        backgroundColor: Colors.lightBlue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: buildForm(
            icon: Icons.book,
            label: "Course Material",
            formContent: [
              buildTextField(_titleController, "Title", Icons.title),
              buildTextField(
                  _descriptionController, "Description", Icons.description,
                  maxLines: 3),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: DropdownButtonFormField<String>(
                  value: _selectedLevel,
                  items: levels
                      .map((level) => DropdownMenuItem(
                            value: level,
                            child: Text(level),
                          ))
                      .toList(),
                  onChanged: (value) => setState(() => _selectedLevel = value),
                  decoration: const InputDecoration(
                    labelText: 'Level',
                    prefixIcon: Icon(Icons.school),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      value == null ? 'Please select a level' : null,
                ),
              ),
              buildFilePicker(
                _selectedFile != null ? "File Selected" : "Select PDF File",
                Icons.attach_file,
                _pickFile,
              ),
              const SizedBox(height: 20),
              _isUploading
                  ? const CircularProgressIndicator()
                  : ElevatedButton.icon(
                      onPressed: _uploadCourse,
                      icon: const Icon(Icons.cloud_upload),
                      label: const Text('Upload'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightBlue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
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
