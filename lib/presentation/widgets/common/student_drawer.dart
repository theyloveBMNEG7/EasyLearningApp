import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../presentation/screens/student/community_chat_screen.dart';

class StudentDrawer extends StatelessWidget {
  const StudentDrawer({super.key});

  Future<Map<String, dynamic>?> _fetchStudentData() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return null;

    final doc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    return doc.exists ? doc.data() : null;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: FutureBuilder<Map<String, dynamic>?>(
        future: _fetchStudentData(),
        builder: (context, snapshot) {
          final userData = snapshot.data;

          return Column(
            children: [
              UserAccountsDrawerHeader(
                decoration: const BoxDecoration(color: Colors.blue),
                currentAccountPicture: CircleAvatar(
                  backgroundImage: userData?['profileImageUrl'] != null
                      ? NetworkImage(userData!['profileImageUrl'])
                      : const AssetImage('assets/images/student_avatar.png')
                          as ImageProvider,
                ),
                accountName: Text(
                  userData?['name'] ?? 'Student',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontFamily: 'OpenSans'),
                ),
                accountEmail: Text(
                  userData?['email'] ?? 'student@easylearning.com',
                  style: const TextStyle(fontFamily: 'OpenSans'),
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  children: [
                    ListTile(
                      leading: const Icon(Icons.chat_bubble_outline,
                          color: Colors.blueAccent),
                      title: const Text('Community Chat'),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const CommunityChatScreen()),
                        );
                      },
                    ),
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
                      leading:
                          const Icon(Icons.help_outline, color: Colors.grey),
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
                  onTap: () async {
                    Navigator.pop(context);
                    await FirebaseAuth.instance.signOut();
                    // TODO: Redirect to login or welcome screen
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
