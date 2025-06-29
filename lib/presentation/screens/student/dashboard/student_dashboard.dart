import 'package:flutter/material.dart';
import 'package:easylearningapp/presentation/widgets/common/student_drawer.dart';

import 'header_section.dart';
import 'recent_courses_section.dart';
import 'weekly_stats_section.dart';
import 'popular_course_section.dart';
import 'past_question_section.dart';

class StudentDashboard extends StatelessWidget {
  const StudentDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const StudentDrawer(),
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          children: const [
            // Header (Greeting + Avatar + Actions)
            HeaderSection(),

            SizedBox(height: 25),

            // Recently Accessed Courses
            RecentCoursesSection(),

            SizedBox(height: 30),

            // Weekly Activity Overview (quiz stats, hours studied, etc.)
            WeeklyStatsSection(),

            SizedBox(height: 26),

            // Popular Courses Recommendation
            PopularCoursesSection(),

            SizedBox(height: 26),

            // Past Questions by Subject or Date
            PastQuestionSection(),

            SizedBox(height: 26),
          ],
        ),
      ),
    );
  }
}
