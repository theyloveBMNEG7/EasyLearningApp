import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RecentCoursesSection extends StatelessWidget {
  const RecentCoursesSection({super.key});

  final List<Map<String, dynamic>> _courses = const [
    {'title': 'Mathematics', 'progress': 0.7},
    {'title': 'English', 'progress': 1.0},
    {'title': 'Computer Science', 'progress': 0.35},
    {'title': 'Economics', 'progress': 0.85},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recent Courses',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w900,
            fontFamily: 'OpenSans',
          ),
        ),
        const SizedBox(height: 18),
        SizedBox(
          height: 100,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _courses.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final course = _courses[index];
              final progress = course['progress'] as double;

              return Material(
                elevation: 3,
                borderRadius: BorderRadius.circular(16),
                color: Colors.white,
                child: Container(
                  width: 180,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              course['title'],
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          if (progress == 1.0)
                            const FaIcon(
                              FontAwesomeIcons.circleCheck,
                              color: Colors.green,
                              size: 18,
                            ),
                        ],
                      ),
                      const Spacer(),
                      Text(
                        '${(progress * 100).toInt()}% completed',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 6),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: LinearProgressIndicator(
                          value: progress,
                          minHeight: 6,
                          backgroundColor: Colors.grey.shade200,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            progress == 1.0 ? Colors.green : Colors.blueAccent,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
