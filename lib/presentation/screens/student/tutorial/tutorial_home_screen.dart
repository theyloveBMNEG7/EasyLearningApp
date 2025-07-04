import 'package:flutter/material.dart';
import 'books_screen.dart';
import 'video_tutorials_screen.dart';

class TutorialHomeScreen extends StatefulWidget {
  const TutorialHomeScreen({super.key});

  @override
  State<TutorialHomeScreen> createState() => _TutorialHomeScreenState();
}

class _TutorialHomeScreenState extends State<TutorialHomeScreen>
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
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        toolbarHeight: 90,
        elevation: 1,
        title: const Text(
          'Tutorials & Books',
          style: TextStyle(
              fontSize: 25, fontWeight: FontWeight.w600, color: Colors.black),
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
                Tab(text: 'Tutorials'),
                Tab(text: 'Books'),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          VideoTutorialsScreen(),
          BooksScreen(),
        ],
      ),
    );
  }
}
