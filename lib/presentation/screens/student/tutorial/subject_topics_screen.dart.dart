import 'package:flutter/material.dart';
import '../../../screens/student/tutorial/topic_video_screen.dart.dart';

class SubjectTopicsScreen extends StatelessWidget {
  final String subject;

  const SubjectTopicsScreen({super.key, required this.subject});

  @override
  Widget build(BuildContext context) {
    final topics = {
      'Programming': ['Algorithms', 'Data Structures', 'OOP'],
      'Economics': ['Microeconomics', 'Macroeconomics'],
      'Mathematics': ['Calculus', 'Statistics'],
    };

    final topicList = topics[subject] ?? [];

    return Scaffold(
      appBar: AppBar(title: Text(subject)),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: topicList.length,
        itemBuilder: (context, index) {
          final topic = topicList[index];
          return Card(
            child: ListTile(
              title: Text(topic),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => TopicVideosScreen(topic: topic),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
