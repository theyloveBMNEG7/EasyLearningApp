import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RecentCoursesSection extends StatelessWidget {
  final String userId;

  const RecentCoursesSection({super.key, required this.userId});

  Stream<List<Map<String, dynamic>>> _fetchRecentProgress() {
    if (userId.isEmpty) return const Stream.empty();

    return FirebaseFirestore.instance
        .collection('tutorial_progress')
        .where('userId', isEqualTo: userId)
        .orderBy('lastUpdated', descending: true)
        .limit(5)
        .snapshots()
        .asyncMap((snapshot) async {
      final progressList = snapshot.docs.map((doc) => doc.data()).toList();

      // Fetch tutorial titles from 'tutorials' collection
      for (var item in progressList) {
        final tutorialId = item['tutorialId'];
        if (tutorialId != null) {
          final tutorialDoc = await FirebaseFirestore.instance
              .collection('tutorials')
              .doc(tutorialId)
              .get();
          item['title'] = tutorialDoc.data()?['title'] ?? 'Untitled';
        }
      }

      return progressList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: _fetchRecentProgress(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final courses = snapshot.data!;
        if (courses.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Text('No recent courses found.'),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
            SizedBox(
              height: 110,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: courses.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final course = courses[index];
                  final progress = (course['progress'] ?? 0.0) as double;
                  final title = course['title'] ?? 'Untitled';

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
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  title,
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
                                progress == 1.0
                                    ? Colors.green
                                    : Colors.blueAccent,
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
      },
    );
  }
}
