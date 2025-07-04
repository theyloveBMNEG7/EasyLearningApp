import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EnterPastQuestionTab extends StatefulWidget {
  const EnterPastQuestionTab({super.key});

  @override
  State<EnterPastQuestionTab> createState() => _EnterPastQuestionTabState();
}

class _EnterPastQuestionTabState extends State<EnterPastQuestionTab> {
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _subject = TextEditingController();
  final _level = TextEditingController();
  final _year = TextEditingController();
  final _fileUrl = TextEditingController();

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      await FirebaseFirestore.instance.collection('past_questions').add({
        'title': _title.text.trim(),
        'subject': _subject.text.trim(),
        'level': _level.text.trim(),
        'year': _year.text.trim(),
        'fileUrl': _fileUrl.text.trim(),
        'timestamp': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Past question added.")),
      );

      _title.clear();
      _subject.clear();
      _level.clear();
      _year.clear();
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
            _buildField(_title, "Title"),
            _buildField(_subject, "Subject"),
            _buildField(_level, "Level"),
            _buildField(_year, "Year"),
            _buildField(_fileUrl, "File URL"),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _submit,
              child: const Text("Submit"),
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
        decoration:
            InputDecoration(labelText: label, border: OutlineInputBorder()),
        validator: (value) =>
            value == null || value.isEmpty ? "Required" : null,
      ),
    );
  }
}
