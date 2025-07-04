import 'package:flutter/material.dart';
import '../admin/content management /enterPastQuestion.dart';
import '../admin/content management /Managesallcontent.dart';
import '../admin/content management /enterbook.dart';

class AdminManageContentScreen extends StatelessWidget {
  const AdminManageContentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Manage Content"),
          backgroundColor: Colors.teal,
          bottom: const TabBar(
            tabs: [
              Tab(text: "Past Questions"),
              Tab(text: "Books"),
              Tab(text: "All Content"),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            EnterPastQuestionTab(),
            EnterBookTab(),
            ManageAllContentTab(),
          ],
        ),
      ),
    );
  }
}
