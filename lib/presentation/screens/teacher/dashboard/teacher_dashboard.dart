import 'package:easylearningapp/presentation/screens/teacher/dashboard/statistics_section.dart';
import 'package:flutter/material.dart';
import 'header_section.dart';
import 'quick_actions_bar.dart';
import 'recent_uploads_section.dart';
import 'upcoming_classes_section.dart';

class TeacherDashboardScreen extends StatelessWidget {
  const TeacherDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Drawer(), // Replace with TeacherDrawer later
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          children: const [
            TeacherHeaderSection(
                teacherName: "Emmanuel"), // hardcoded name for now
            SizedBox(height: 25),
            StatisticsSection(),
            SizedBox(height: 2),
            QuickActionsBar(),
            SizedBox(height: 15),
            RecentUploadsSection(),
            SizedBox(height: 26),
            UpcomingClassesSection(),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
