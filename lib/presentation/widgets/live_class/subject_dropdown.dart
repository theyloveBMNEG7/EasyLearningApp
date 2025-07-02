import 'package:flutter/material.dart';

class SubjectDropdown extends StatelessWidget {
  final void Function(String?) onChanged;
  final List<String> subjects;

  const SubjectDropdown({
    super.key,
    required this.onChanged,
    this.subjects = const ['Math', 'Programming', 'Physics', 'AI'],
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      decoration: const InputDecoration(
        labelText: "Subject",
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.book),
      ),
      items: subjects
          .map((sub) => DropdownMenuItem(value: sub, child: Text(sub)))
          .toList(),
      onChanged: onChanged,
    );
  }
}
