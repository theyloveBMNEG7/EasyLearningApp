import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../presentation/screens/student/community_chat_screen.dart';

class StudentDrawer extends StatelessWidget {
  const StudentDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(color: Colors.blue),
            currentAccountPicture: const CircleAvatar(
              backgroundImage: AssetImage('assets/images/student_avatar.png'),
            ),
            accountName: const Text(
              'Emmanuel',
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontFamily: 'OPenSans'),
            ),
            accountEmail: const Text(
              'student@easylearning.com',
              style: TextStyle(fontFamily: 'OpenSans'),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: [
                ListTile(
                  leading:
                      const Icon(Icons.live_tv_rounded, color: Colors.blue),
                  title: const Text('Live Class'),
                  onTap: () {
                    Navigator.pop(context);
                    // TODO: Navigate to LiveClassScreen
                  },
                ),
                ListTile(
                    leading: const Icon(Icons.chat_bubble_outline,
                        color: Colors.blueAccent),
                    title: const Text('Community Chat'),
                    onTap: () {
                      Navigator.pop(context); // Close the drawer
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const CommunityChatScreen(),
                        ),
                      );
                    }),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.settings, color: Colors.grey),
                  title: const Text('Settings'),
                  onTap: () {
                    Navigator.pop(context);
                    // TODO: Navigate to SettingsScreen
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.help_outline, color: Colors.grey),
                  title: const Text('Help'),
                  onTap: () {
                    Navigator.pop(context);
                    // TODO: Navigate to HelpScreen
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 25),
            child: ListTile(
              leading: const Icon(Icons.logout, color: Colors.redAccent),
              title: const Text('Logout'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Handle logout logic
              },
            ),
          ),
        ],
      ),
    );
  }
}
