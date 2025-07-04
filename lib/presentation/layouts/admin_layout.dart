import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../presentation/screens/admin/admin_dashboard.dart';
import '../../presentation/screens/admin/admin_class_monitor.dart';
import '../../presentation/screens/admin/create_teacher_screen.dart';
import '../../presentation/screens/admin/manage_content_screen.dart';
import '../../presentation/screens/admin/manage_users_screen.dart';

class AdminLayout extends StatefulWidget {
  final int initialIndex;

  const AdminLayout({super.key, this.initialIndex = 0});

  @override
  State<AdminLayout> createState() => _AdminLayoutState();
}

class _AdminLayoutState extends State<AdminLayout> {
  late int _index;

  @override
  void initState() {
    super.initState();
    _index = widget.initialIndex;
  }

  final List<Widget> _tabs = const [
    AdminDashboardScreen(),
    AdminClassMonitorScreen(),
    CreateTeacherScreen(),
    //AdminUserManagementScreen(),
    //AdminAiLogsScreen(),
  ];

  final List<BottomNavigationBarItem> _navItems = const [
    BottomNavigationBarItem(
      icon: FaIcon(FontAwesomeIcons.gauge),
      label: 'Dashboard',
    ),
    BottomNavigationBarItem(
      icon: FaIcon(FontAwesomeIcons.video),
      label: 'Live',
    ),
    BottomNavigationBarItem(
      icon: FaIcon(FontAwesomeIcons.chartColumn),
      label: 'Analytics',
    ),
    BottomNavigationBarItem(
      icon: FaIcon(FontAwesomeIcons.usersGear),
      label: 'Users',
    ),
    BottomNavigationBarItem(
      icon: FaIcon(FontAwesomeIcons.robot),
      label: 'AI Logs',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _tabs[_index],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: _navItems,
      ),
    );
  }
}
