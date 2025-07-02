import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UpcomingClassSection extends StatelessWidget {
  const UpcomingClassSection({super.key});

  @override
  Widget build(BuildContext context) {
    final upcoming = [
      {
        'title': 'Algebra Basics',
        'time': DateTime.now().add(const Duration(minutes: 45)),
      },
      {
        'title': 'Chemistry Lab',
        'time': DateTime.now().add(const Duration(hours: 2)),
      },
    ];

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
        ...upcoming.map((session) {
          final time = session['time'] as DateTime;
          final now = DateTime.now();
          final timeUntil = time.difference(now);

          String relativeTime;
          if (timeUntil.inMinutes < 60) {
            relativeTime = 'in ${timeUntil.inMinutes} min';
          } else {
            final hours = timeUntil.inHours;
            final mins = timeUntil.inMinutes % 60;
            relativeTime =
                'in $hours hr${hours > 1 ? 's' : ''} ${mins > 0 ? '$mins min' : ''}';
          }

          final formattedTime = DateFormat('hh:mm a').format(time);

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
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              leading: const Icon(Icons.live_tv_rounded,
                  color: Colors.lightBlueAccent, size: 32),
              title: Text(
                session['title'] as String,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              subtitle: Text(
                '$formattedTime • $relativeTime',
                style: const TextStyle(fontSize: 13, color: Colors.grey),
              ),
              trailing: ElevatedButton.icon(
                onPressed: () {
                  // TODO: Navigate to session
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlue,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
        }),
      ],
    );
  }
}
