import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TeacherHeaderSection extends StatelessWidget {
  final String teacherName;
  final String? avatarImagePath;
  final int unreadNotifications; // 👈 Add this

  const TeacherHeaderSection({
    super.key,
    required this.teacherName,
    this.avatarImagePath,
    this.unreadNotifications = 0, // 👈 Default to 0
  });

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(width: 10),

            // Avatar
            CircleAvatar(
              radius: 24,
              backgroundImage: avatarImagePath != null
                  ? AssetImage(avatarImagePath!)
                  : const AssetImage('assets/images/teacher_avatar.png'),
            ),

            const SizedBox(width: 12),

            // Greeting
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Hello, welcome back.",
                    style: TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                  Text(
                    teacherName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),

            // Notification Icon with Badge
            Stack(
              children: [
                IconButton(
                  icon: const FaIcon(FontAwesomeIcons.bell, size: 18),
                  onPressed: () {
                    Navigator.pushNamed(context, '/notifications');
                  },
                  tooltip: "Notifications",
                  splashRadius: 20,
                ),
                if (unreadNotifications > 0)
                  Positioned(
                    right: 6,
                    top: 6,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.redAccent,
                        shape: BoxShape.circle,
                      ),
                      constraints:
                          const BoxConstraints(minWidth: 18, minHeight: 18),
                      child: Text(
                        unreadNotifications > 9 ? '9+' : '$unreadNotifications',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
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
