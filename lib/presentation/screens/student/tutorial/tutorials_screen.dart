import 'package:flutter/material.dart';
import '../../../screens/student/tutorial/subject_topics_screen.dart.dart';

class TutorialsScreen extends StatelessWidget {
  final List<Map<String, String>> subjects = [
    {
      'title': 'Programming',
      'image': 'assets/images/programming.jpg',
    },
    {
      'title': 'Economics',
      'image': 'assets/images/economics.jpg',
    },
    {
      'title': 'Mathematics',
      'image': 'assets/images/math.jpg',
    },
  ];

  TutorialsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tutorials')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search for a course...',
                prefixIcon: const Icon(Icons.search),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onChanged: (query) {
                // TODO: Implement search logic
              },
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: subjects.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
              ),
              itemBuilder: (context, index) {
                final subject = subjects[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            SubjectTopicsScreen(subject: subject['title']!),
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child:
                              Image.asset(subject['image']!, fit: BoxFit.cover),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(subject['title']!,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
