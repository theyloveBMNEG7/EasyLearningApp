import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:easylearningapp/core/constants/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HeaderSection extends StatelessWidget {
  const HeaderSection({super.key, required String userId});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final user = FirebaseAuth.instance.currentUser;

    final displayName = user?.displayName ?? 'Student';
    final email = user?.email ?? '';
    final userId = user?.uid ?? '';

    return Builder(
      builder: (context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Drawer Icon
            IconButton(
              icon: const Icon(Icons.menu_rounded, size: 28),
              onPressed: () => Scaffold.of(context).openDrawer(),
              splashRadius: 22,
            ),

            const SizedBox(width: 10),

            // Avatar
            const CircleAvatar(
              radius: 24,
              backgroundImage: AssetImage('assets/images/student_avatar.png'),
            ),

            const SizedBox(width: 12),

            // Greeting
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Hi, welcome back.",
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    displayName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    email,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),

            // Notification Button
            IconButton(
              icon: const FaIcon(FontAwesomeIcons.bell, size: 18),
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  RoutePaths.notifications,
                  arguments: {
                    'userRole': 'student',
                    'userId': userId,
                  },
                );
              },
              tooltip: "Notifications",
              splashRadius: 20,
            ),

            // Overflow Menu
            PopupMenuButton<String>(
              tooltip: "More options",
              icon: const FaIcon(FontAwesomeIcons.ellipsisVertical, size: 18),
              onSelected: (value) {
                // TODO: Handle actions
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'profile',
                  child: Row(
                    children: [
                      FaIcon(FontAwesomeIcons.user, size: 16),
                      SizedBox(width: 10),
                      Text('Profile'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'settings',
                  child: Row(
                    children: [
                      FaIcon(FontAwesomeIcons.gear, size: 16),
                      SizedBox(width: 10),
                      Text('Settings'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'help',
                  child: Row(
                    children: [
                      FaIcon(FontAwesomeIcons.circleQuestion, size: 16),
                      SizedBox(width: 10),
                      Text('Help'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'logout',
                  child: Row(
                    children: [
                      FaIcon(FontAwesomeIcons.arrowRightFromBracket, size: 16),
                      SizedBox(width: 10),
                      Text('Logout'),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
