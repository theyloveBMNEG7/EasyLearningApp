import 'package:flutter/material.dart';
import '../../../../core/utils/local_question_storage.dart';

class CorrectionScreen extends StatelessWidget {
  final Map<String, String> data;

  const CorrectionScreen({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final questionId = data['id'] ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Correction'),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.check_circle_outline),
            tooltip: 'Mark as Reviewed',
            onPressed: () async {
              await LocalQuestionStorage.markAsReviewed(questionId);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Marked as reviewed')),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${data['subject']} • ${data['year']}',
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 16),
            Text(data['question'] ?? '',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
            const SizedBox(height: 24),
            const Text('✅ Correct Answer:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(data['answer'] ?? '', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 24),
            const Text('🧠 Explanation:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(data['explanation'] ?? '',
                style: const TextStyle(fontSize: 15)),
          ],
        ),
      ),
    );
  }
}
