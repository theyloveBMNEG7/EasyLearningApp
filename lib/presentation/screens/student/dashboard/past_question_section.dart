import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../tutorial/tutorials_screen.dart';

class PastQuestionSection extends StatelessWidget {
  const PastQuestionSection({super.key});

  final List<Map<String, String>> _pastPapers = const [
    {
      'title': 'Business Law',
      'description': 'Master corporate regulations and legal strategy.',
    },
    {
      'title': 'General Mathematics',
      'description': 'Foundational math concepts for exam success.',
    },
    {
      'title': 'Marketing Management',
      'description': 'Understand targeting, strategy, and value delivery.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Past Questions',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w900,
            fontFamily: 'OpenSans',
          ),
        ),
        const SizedBox(height: 16),
        Column(
          children: _pastPapers.map((course) {
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    blurRadius: 6,
                    offset: Offset(0, 3),
                    color: Colors.black12,
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const FaIcon(
                    FontAwesomeIcons.filePdf,
                    color: Colors.redAccent,
                    size: 28,
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          course['title']!,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          course['description']!,
                          style: TextStyle(
                            fontSize: 13.5,
                            color: Colors.grey[800],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: IconButton(
                      tooltip: 'Open Past Question',
                      icon: const Icon(Icons.arrow_forward_ios_rounded,
                          size: 18, color: Colors.blue),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const TutorialsScreen(),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
