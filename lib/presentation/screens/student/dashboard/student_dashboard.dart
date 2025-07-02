import 'package:flutter/material.dart';
import 'package:easylearningapp/presentation/widgets/common/student_drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'header_section.dart';
import 'recent_courses_section.dart';
import 'weekly_stats_section.dart';
import 'popular_course_section.dart';
import 'past_question_section.dart';
import '../../../widgets/live_class/upcoming_class_section.dart';
//import '../../../widgets/live_class/join_link_bar.dart';

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
            HeaderSection(),
            SizedBox(height: 25),
            RecentCoursesSection(),
            SizedBox(height: 30),
            UpcomingClassSection(),
            SizedBox(height: 26),
            // JoinLinkBar(),
            SizedBox(height: 20),
            WeeklyStatsSection(),
            SizedBox(height: 26),
            PopularCoursesSection(),
            SizedBox(height: 26),
            PastQuestionSection(),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
