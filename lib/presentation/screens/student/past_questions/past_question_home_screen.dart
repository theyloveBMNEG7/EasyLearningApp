import 'package:flutter/material.dart';
import 'past_question_screen.dart';
import 'reviewed_question_screen.dart';

class PastQuestionHomeScreen extends StatefulWidget {
  const PastQuestionHomeScreen({super.key});

  @override
  State<PastQuestionHomeScreen> createState() => _PastQuestionHomeScreenState();
}

class _PastQuestionHomeScreenState extends State<PastQuestionHomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      appBar: AppBar(
        toolbarHeight: 90,
        elevation: 1,
        title: const Text(
          'Past Questions',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(25),
          child: Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              labelColor: theme.colorScheme.primary,
              unselectedLabelColor: Colors.grey,
              labelStyle: const TextStyle(fontWeight: FontWeight.w600),
              indicatorColor: theme.colorScheme.primary,
              tabs: const [
                Tab(text: 'Questions'),
                Tab(text: 'Corrections'),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          PastQuestionScreen(),
          ReviewedQuestionScreen(),
        ],
      ),
    );
  }
}
