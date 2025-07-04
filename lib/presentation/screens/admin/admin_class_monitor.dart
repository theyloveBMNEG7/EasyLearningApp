import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminClassMonitorScreen extends StatelessWidget {
  const AdminClassMonitorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Monitor Live Classes"),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('live_classes')
            .orderBy('time')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No live or upcoming classes."));
          }

          final liveClasses = snapshot.data!.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return {
              "teacher": data['teacher'] ?? 'Unknown',
              "subject": data['subject'] ?? 'Unknown',
              "level": data['level'] ?? 'N/A',
              "time": data['time'] ?? 'TBD',
              "status": data['status'] ?? 'Unknown',
            };
          }).toList();

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: liveClasses.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final session = liveClasses[index];
              // return _buildClassCard(context, session);
            },
          );
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
