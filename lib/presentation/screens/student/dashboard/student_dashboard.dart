import 'package:flutter/material.dart';
import 'header_section.dart';
import 'recent_courses_section.dart';
import 'weekly_stats_section.dart';
import 'popular_course_section.dart';
import 'past_question_section.dart';
import 'dashboard_divider.dart';

class StudentDashboard extends StatelessWidget {
  const StudentDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          children: const [
            HeaderSection(),
            DashboardDivider(),
            RecentCoursesSection(),
            DashboardDivider(),
            WeeklyStatsSection(),
            DashboardDivider(),
            PastQuestionSection(),
            DashboardDivider(),
            PopularCoursesSection(),
          ],
        ),
      ),
    );
  }
}
