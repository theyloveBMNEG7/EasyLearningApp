import 'package:flutter/material.dart';
import '../../../widgets/past_questions/question_card.dart';
import '../../../../core/utils/local_question_storage.dart';
import 'correction_screen.dart';

class ReviewedQuestionScreen extends StatefulWidget {
  const ReviewedQuestionScreen({super.key});

  @override
  State<ReviewedQuestionScreen> createState() => _ReviewedQuestionScreenState();
}

class _ReviewedQuestionScreenState extends State<ReviewedQuestionScreen> {
  List<Map<String, String>> reviewedQuestions = [];

  @override
  void initState() {
    super.initState();
    _loadReviewed();
  }

  Future<void> _loadReviewed() async {
    final reviewedIds = await LocalQuestionStorage.getReviewedQuestions();

    // Simulated question list — replace with real data or fetch from backend
    final allQuestions = [
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

    setState(() {
      reviewedQuestions =
          allQuestions.where((q) => reviewedIds.contains(q['id'])).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (reviewedQuestions.isEmpty) {
      return const Center(
        child: Text(
          '⭐ No reviewed questions yet.',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: reviewedQuestions.length,
      itemBuilder: (context, index) {
        final q = reviewedQuestions[index];
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
    );
  }
}
