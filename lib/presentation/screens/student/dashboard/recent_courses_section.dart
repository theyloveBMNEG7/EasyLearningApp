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
        // Section Title
        const Padding(
          padding: EdgeInsets.only(bottom: 12),
          child: Text(
            'Recent Courses',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              fontFamily: 'OpenSans',
            ),
          ),
        ),

        // Horizontal Course List
        SizedBox(
          height: 110,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _courses.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final course = _courses[index];
              final progress = course['progress'] as double;

              return Material(
                elevation: 3,
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                clipBehavior: Clip.antiAlias,
                child: Container(
                  width: 180,
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Course title + check if completed
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              course['title'],
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (progress == 1.0)
                            const Padding(
                              padding: EdgeInsets.only(left: 4),
                              child: FaIcon(
                                FontAwesomeIcons.circleCheck,
                                color: Colors.green,
                                size: 16,
                              ),
                            ),
                        ],
                      ),

                      const Spacer(),

                      // Progress text
                      Text(
                        '${(progress * 100).toInt()}% completed',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black54,
                        ),
                      ),

                      const SizedBox(height: 6),

                      // Progress bar
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
