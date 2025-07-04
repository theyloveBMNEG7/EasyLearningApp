import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EnterBookTab extends StatefulWidget {
  const EnterBookTab({super.key});

  @override
  State<EnterBookTab> createState() => _EnterBookTabState();
}

class _EnterBookTabState extends State<EnterBookTab> {
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _author = TextEditingController();
  final _subject = TextEditingController();
  final _fileUrl = TextEditingController();

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      await FirebaseFirestore.instance.collection('books').add({
        'title': _title.text.trim(),
        'author': _author.text.trim(),
        'subject': _subject.text.trim(),
        'fileUrl': _fileUrl.text.trim(),
        'timestamp': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("📘 Book added successfully.")),
      );

      _title.clear();
      _author.clear();
      _subject.clear();
      _fileUrl.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            _buildField(_title, "Book Title"),
            _buildField(_author, "Author"),
            _buildField(_subject, "Subject"),
            _buildField(_fileUrl, "File URL (PDF link)"),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _submit,
              icon: const Icon(Icons.upload_file),
              label: const Text("Submit Book"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        validator: (value) =>
            value == null || value.isEmpty ? "Required" : null,
      ),
    );
  }
}
