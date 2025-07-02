import 'package:flutter/material.dart';
import '../../screens/student/dashboard/student_dashboard.dart';
import '../../screens/student/tutorial/tutorials_screen.dart';
import '../../screens/student/quiz/quiz_screen.dart';
import '../../screens/student/past_questions/past_question_home_screen.dart';
import '../../../presentation/widgets/common/student_drawer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StudentLayout extends StatefulWidget {
  final int initialIndex;

  const StudentLayout({super.key, this.initialIndex = 0});

  @override
  State<StudentLayout> createState() => _StudentLayoutState();
}

class _StudentLayoutState extends State<StudentLayout> {
  late int _index;

  @override
  void initState() {
    super.initState();
    _index = widget.initialIndex;
  }

  final List<Widget> _tabs = [
    StudentDashboard(),
    TutorialsScreen(),
    QuizScreen(),
    PastQuestionHomeScreen(),
    //StudentProfile(),
  ];

  final List<BottomNavigationBarItem> _navItems = const [
    BottomNavigationBarItem(
        icon: FaIcon(FontAwesomeIcons.house), label: 'Home'),
    BottomNavigationBarItem(
        icon: FaIcon(FontAwesomeIcons.bookOpen), label: 'Tutorials'),
    BottomNavigationBarItem(
        icon: FaIcon(FontAwesomeIcons.penToSquare), label: 'Quiz'),
    BottomNavigationBarItem(
        icon: FaIcon(FontAwesomeIcons.filePdf), label: 'Papers & Corrections'),
    BottomNavigationBarItem(
        icon: FaIcon(FontAwesomeIcons.user), label: 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const StudentDrawer(),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        child: _tabs[_index],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: _navItems,
      ),
    );
  }
}
