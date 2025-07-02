import 'package:flutter/material.dart';

class LevelDropdown extends StatelessWidget {
  final void Function(String?) onChanged;

  const LevelDropdown({super.key, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      decoration: const InputDecoration(
        labelText: "Level",
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.school),
      ),
      items: ["Year 1", "Year 2"]
          .map((level) => DropdownMenuItem(value: level, child: Text(level)))
          .toList(),
      onChanged: onChanged,
    );
  }
}
