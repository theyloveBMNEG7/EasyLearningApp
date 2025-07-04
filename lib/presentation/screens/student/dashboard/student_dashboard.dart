import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:easylearningapp/presentation/widgets/common/student_drawer.dart';

import 'header_section.dart';
import 'recent_courses_section.dart';
import 'weekly_stats_section.dart';
import 'popular_course_section.dart';
import 'past_question_section.dart';
import '../../../widgets/live_class/upcoming_class_section.dart';
import '../../../../core/constants/routes.dart';

class StudentDashboard extends StatelessWidget {
  const StudentDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      drawer: const StudentDrawer(),
      backgroundColor: const Color(0xFFF5F7FA),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, RoutePaths.aiTutor);
        },
        backgroundColor: Colors.blueAccent,
        tooltip: 'Ask AI Tutor',
        child: const Icon(Icons.smart_toy_rounded, size: 28),
        shape: const CircleBorder(),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          children: [
            HeaderSection(userId: user?.uid ?? ''),
            const SizedBox(height: 25),
            RecentCoursesSection(userId: user?.uid ?? ''),
            const SizedBox(height: 30),
            UpcomingClassSection(userId: user?.uid ?? ''),
            const SizedBox(height: 26),
            WeeklyStatsSection(userId: user?.uid ?? ''),
            const SizedBox(height: 26),
            PopularCoursesSection(),
            const SizedBox(height: 26),
            PastQuestionSection(),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
