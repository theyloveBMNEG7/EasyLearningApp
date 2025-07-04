import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  int studentCount = 0;
  int teacherCount = 0;
  int tutorialCount = 0;
  int questionCount = 0;
  int correctionCount = 0;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _fetchStats();
  }

  Future<void> _fetchStats() async {
    final users = await FirebaseFirestore.instance.collection('users').get();
    final tutorials =
        await FirebaseFirestore.instance.collection('tutorials').get();
    final questions =
        await FirebaseFirestore.instance.collection('past_questions').get();
    final corrections =
        await FirebaseFirestore.instance.collection('corrections').get();

    int students = 0;
    int teachers = 0;

    for (var doc in users.docs) {
      final role = doc['role'];
      if (role == 'student') students++;
      if (role == 'teacher') teachers++;
    }

    setState(() {
      studentCount = students;
      teacherCount = teachers;
      tutorialCount = tutorials.size;
      questionCount = questions.size;
      correctionCount = corrections.size;
      loading = false;
    });
  }

  Widget _buildStatCard(String title, int count, IconData icon, Color color) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.all(16),
        width: double.infinity,
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: color.withOpacity(0.1),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text('$count',
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Dashboard')),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildStatCard(
                    'Students', studentCount, Icons.school, Colors.blue),
                _buildStatCard(
                    'Teachers', teacherCount, Icons.person, Colors.green),
                _buildStatCard('Tutorials', tutorialCount, Icons.menu_book,
                    Colors.deepPurple),
                _buildStatCard('Past Questions', questionCount,
                    Icons.help_outline, Colors.orange),
                _buildStatCard('Corrections', correctionCount,
                    Icons.check_circle, Colors.teal),
              ],
            ),
    );
  }
}
