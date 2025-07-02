import 'package:flutter/material.dart';

class AdminClassMonitorScreen extends StatelessWidget {
  const AdminClassMonitorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy data for ongoing classes
    final liveClasses = [
      {
        "teacher": "Mr. Emmanuel",
        "subject": "Programming",
        "level": "HND Year 2",
        "time": "10:00 AM - 11:30 AM",
        "status": "Live",
      },
      {
        "teacher": "Ms. Angela",
        "subject": "Networking",
        "level": "BTS Year 1",
        "time": "12:00 PM - 1:30 PM",
        "status": "Upcoming",
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Monitor Live Classes"),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: liveClasses.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final session = liveClasses[index];
          return _buildClassCard(context, session);
        },
      ),
    );
  }

  Widget _buildClassCard(BuildContext context, Map<String, String> session) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(session['subject']!,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text("Teacher: ${session['teacher']}"),
            Text("Level: ${session['level']}"),
            Text("Time: ${session['time']}"),
            const SizedBox(height: 8),
            Row(
              children: [
                Chip(
                  label: Text(session['status']!),
                  backgroundColor:
                      session['status'] == "Live" ? Colors.red : Colors.orange,
                  labelStyle: const TextStyle(color: Colors.white),
                ),
                const Spacer(),
                ElevatedButton.icon(
                  onPressed: () {
                    // TODO: Navigate to observer/monitor class page
                  },
                  icon: const Icon(Icons.visibility),
                  label: const Text("View"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
