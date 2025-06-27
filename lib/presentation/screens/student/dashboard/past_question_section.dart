import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../tutorial/tutorials_screen.dart';

class PopularCoursesSection extends StatelessWidget {
  const PopularCoursesSection({super.key});

  final List<Map<String, String>> _popularCourses = const [
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
        const SizedBox(height: 12),
        Column(
          children: _popularCourses.map((course) {
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    blurRadius: 4,
                    offset: Offset(1, 2),
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
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          course['title']!,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          course['description']!,
                          style: const TextStyle(
                            fontSize: 13.5,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  IconButton(
                      tooltip: 'Open Tutorial',
                      icon: const Icon(Icons.arrow_forward_ios_rounded,
                          size: 20, color: Colors.blue),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const TutorialsScreen()),
                        );
                      }),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
