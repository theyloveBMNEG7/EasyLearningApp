import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HeaderSection extends StatelessWidget {
  const HeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(
          height: 12,
        ),
        const CircleAvatar(
          radius: 26,
          backgroundImage: AssetImage('assets/images/student_avatar.png'),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text("Hi, welcome back",
                  style: TextStyle(color: Color.fromARGB(255, 131, 131, 131))),
              Text("Emmanuel",
                  style: TextStyle(
                      fontSize: 22,
                      fontFamily: 'OpenSans',
                      fontWeight: FontWeight.w900)),
            ],
          ),
        ),
        IconButton(
          icon: FaIcon(FontAwesomeIcons.bell),
          onPressed: () {
            Navigator.pushNamed(context, '/notifications');
          },
        ),
        PopupMenuButton<String>(
          icon: const FaIcon(FontAwesomeIcons.ellipsisVertical),
          onSelected: (value) {
            // handle actions
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'profile',
              child: Row(
                children: const [
                  FaIcon(FontAwesomeIcons.user, size: 16),
                  SizedBox(width: 10),
                  Text('Profile'),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'settings',
              child: Row(
                children: const [
                  FaIcon(FontAwesomeIcons.gear, size: 16),
                  SizedBox(width: 10),
                  Text('Settings'),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'help',
              child: Row(
                children: const [
                  FaIcon(FontAwesomeIcons.circleQuestion, size: 16),
                  SizedBox(width: 10),
                  Text('Help'),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'logout',
              child: Row(
                children: const [
                  FaIcon(FontAwesomeIcons.arrowRightFromBracket, size: 16),
                  SizedBox(width: 10),
                  Text('Logout'),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
