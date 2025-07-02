import 'package:flutter/material.dart';

class SubjectFilterBar extends StatelessWidget {
  final List<String> subjects;
  final String selectedSubject;
  final ValueChanged<String> onSelected;

  const SubjectFilterBar({
    super.key,
    required this.subjects,
    required this.selectedSubject,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: subjects.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final subject = subjects[index];
          final isSelected = subject == selectedSubject;

          return ChoiceChip(
            label: Text(subject),
            selected: isSelected,
            onSelected: (_) => onSelected(subject),
            selectedColor: Colors.blueAccent,
            backgroundColor: Colors.grey[200],
            labelStyle: TextStyle(
              color: isSelected ? Colors.white : Colors.black87,
              fontWeight: FontWeight.w500,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          );
        },
      ),
    );
  }
}
