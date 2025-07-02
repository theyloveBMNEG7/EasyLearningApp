import 'package:flutter/material.dart';
import '../../../widgets/past_questions/question_card.dart';
import '../../../widgets/past_questions/subject_filter_bar.dart';
import 'correction_screen.dart';

class PastQuestionScreen extends StatefulWidget {
  const PastQuestionScreen({super.key});

  @override
  State<PastQuestionScreen> createState() => _PastQuestionScreenState();
}

class _PastQuestionScreenState extends State<PastQuestionScreen> {
  final List<Map<String, String>> allQuestions = [
    {
      'id': 'q1',
      'subject': 'Math',
      'year': '2022',
      'question': 'Solve for x: 2x + 3 = 11',
      'answer': 'x = 4',
      'explanation': 'Subtract 3, then divide by 2.',
    },
    {
      'id': 'q2',
      'subject': 'Physics',
      'year': '2021',
      'question': 'State Newton’s second law.',
      'answer': 'F = ma',
      'explanation': 'Force equals mass times acceleration.',
    },
  ];

  String selectedSubject = 'All';

  @override
  Widget build(BuildContext context) {
    final subjects = ['All', 'Math', 'Physics'];
    final filtered = selectedSubject == 'All'
        ? allQuestions
        : allQuestions.where((q) => q['subject'] == selectedSubject).toList();

    return Column(
      children: [
        SubjectFilterBar(
          subjects: subjects,
          selectedSubject: selectedSubject,
          onSelected: (subject) {
            setState(() => selectedSubject = subject);
          },
        ),
        const SizedBox(height: 16),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: filtered.length,
            itemBuilder: (context, index) {
              final q = filtered[index];
              return QuestionCard(
                subject: q['subject']!,
                year: q['year']!,
                question: q['question']!,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CorrectionScreen(data: q),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
