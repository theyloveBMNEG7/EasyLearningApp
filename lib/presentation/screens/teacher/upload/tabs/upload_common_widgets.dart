// lib/presentation/screens/teacher/tabs/upload_common_widgets.dart
import 'package:flutter/material.dart';

/// Common Text Field widget with validation
Widget buildTextField(
  TextEditingController controller,
  String label,
  IconData icon, {
  int maxLines = 1,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10),
    child: TextFormField(
      controller: controller,
      maxLines: maxLines,
      validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(),
      ),
    ),
  );
}

/// Common form wrapper for upload tabs
Widget buildForm({
  required IconData icon,
  required String label,
  required List<Widget> formContent,
}) {
  return Card(
    elevation: 6,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 42, color: Colors.blue),
          const SizedBox(height: 8),
          Text(
            "Upload $label",
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ...formContent,
        ],
      ),
    ),
  );
}

/// Placeholder for file picker button
Widget buildFilePicker(String label, IconData icon, VoidCallback onPressed) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 12),
    child: ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 50),
      ),
    ),
  );
}
