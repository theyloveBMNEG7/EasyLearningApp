import 'package:flutter/material.dart';
import 'package:easylearningapp/core/constants/routes.dart';

class UpcomingClassesSection extends StatelessWidget {
  const UpcomingClassesSection({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy upcoming classes list
    final classes = [
      {'subject': 'Mathematics', 'date': '2025-07-02', 'time': '10:00 AM'},
      {'subject': 'Programming', 'date': '2025-07-04', 'time': '2:00 PM'},
      {'subject': 'Data Science', 'date': '2025-07-05', 'time': '11:00 AM'},
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Upcoming Classes",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: classes.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final liveClass = classes[index];
              return ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                leading: const Icon(Icons.video_call, color: Colors.lightBlue),
                title: Text(
                  liveClass['subject']!,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: Text('${liveClass['date']} • ${liveClass['time']}'),
                trailing: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, RoutePaths.hostClass);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightBlue,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(60),
                    ),
                  ),
                  child:
                      const Text('Join', style: TextStyle(color: Colors.white)),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
