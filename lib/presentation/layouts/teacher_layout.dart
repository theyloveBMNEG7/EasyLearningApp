import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../presentation/screens/teacher/live class/live_class_screen.dart';
import '../../presentation/screens/teacher/dashboard/teacher_dashboard.dart';
import '../screens/teacher/upload/upload_screen.dart';
// import '../../widgets/common/teacher_drawer.dart'; // Optional future use

class TeacherLayout extends StatefulWidget {
  final int initialIndex;

  const TeacherLayout({super.key, this.initialIndex = 0});

  @override
  State<TeacherLayout> createState() => _TeacherLayoutState();
}

class _TeacherLayoutState extends State<TeacherLayout> {
  late int _index;

  @override
  void initState() {
    super.initState();
    _index = widget.initialIndex;
  }

  final List<Widget> _tabs = const [
    TeacherDashboardScreen(),
    UploadScreen(),
    LiveClassScreen(),
    //TeacherProfileScreen(),
  ];

  final List<BottomNavigationBarItem> _navItems = const [
    BottomNavigationBarItem(
      icon: FaIcon(FontAwesomeIcons.house),
      label: 'Home',
    ),
    BottomNavigationBarItem(
      icon: FaIcon(FontAwesomeIcons.fileArrowUp),
      label: 'Upload',
    ),
    BottomNavigationBarItem(
      icon: FaIcon(FontAwesomeIcons.video),
      label: 'Live Class',
    ),
    BottomNavigationBarItem(
      icon: FaIcon(FontAwesomeIcons.user),
      label: 'Profile',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // drawer: const TeacherDrawer(), // Uncomment when you build it
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
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
