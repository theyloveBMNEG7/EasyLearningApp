import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class UpcomingClassSection extends StatelessWidget {
  final String userId;
  final String? level;
  final String? department;

  const UpcomingClassSection({
    super.key,
    required this.userId,
    this.level,
    this.department,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            'Upcoming Live Classes',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              fontFamily: 'OpenSans',
              color: Colors.black,
            ),
          ),
        ),
        const SizedBox(height: 8),
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('schedules')
              .where('level', isEqualTo: level)
              .orderBy('scheduled_at')
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final docs = snapshot.data!.docs.where((doc) {
              final data = doc.data() as Map<String, dynamic>;
              final scheduledAt = DateTime.tryParse(data['scheduled_at'] ?? '');
              return scheduledAt != null && scheduledAt.isAfter(now);
            }).toList();

            if (docs.isEmpty) {
              return const Center(child: Text('No upcoming classes.'));
            }

            return Column(
              children: docs.map((doc) {
                final data = doc.data() as Map<String, dynamic>;
                final subject = data['subject'] ?? 'Untitled';
                final note = data['note'] ?? '';
                final scheduledAt = DateTime.parse(data['scheduled_at']);
                final timeUntil = scheduledAt.difference(now);

                String relativeTime;
                if (timeUntil.inMinutes < 60) {
                  relativeTime = 'in ${timeUntil.inMinutes} min';
                } else {
                  final hours = timeUntil.inHours;
                  final mins = timeUntil.inMinutes % 60;
                  relativeTime =
                      'in $hours hr${hours > 1 ? 's' : ''} ${mins > 0 ? '$mins min' : ''}';
                }

                final formattedTime =
                    DateFormat('EEE, MMM d • hh:mm a').format(scheduledAt);

                return Container(
                  margin: const EdgeInsets.only(bottom: 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blueAccent.withOpacity(0.08),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    leading: const Icon(Icons.live_tv_rounded,
                        color: Colors.lightBlueAccent, size: 32),
                    title: Text(
                      subject,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Text(
                      '$formattedTime • $relativeTime\n$note',
                      style: const TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                    trailing: ElevatedButton.icon(
                      onPressed: () {
                        // TODO: Navigate to live session or class details
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightBlue,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                      ),
                      icon: const Icon(
                        Icons.play_arrow,
                        size: 18,
                        color: Colors.white,
                      ),
                      label: const Text(
                        'Join',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }
}
