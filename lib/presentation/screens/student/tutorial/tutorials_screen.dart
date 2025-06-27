import 'package:flutter/material.dart';
import './tutorial_video_screen.dart';

class TutorialsScreen extends StatefulWidget {
  const TutorialsScreen({super.key});

  @override
  State<TutorialsScreen> createState() => _TutorialsScreenState();
}

class _TutorialsScreenState extends State<TutorialsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, dynamic>> tutorials = [
    {
      'title': 'Microeconomics',
      'rating': 4.8,
      'students': '950 students',
      'image': 'assets/images/economics.jpg',
      'videoUrl': 'https://yourdomain.com/videos/microeconomics.mp4',
    },
    {
      'title': 'Financial Accounting',
      'rating': 4.7,
      'students': '1.5k students',
      'image': 'assets/images/accounting.jpg',
      'videoUrl': 'https://yourdomain.com/videos/finance_intro.mp4',
    },
  ];

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

  Widget buildCourseCard(Map<String, dynamic> t) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      elevation: 2,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => TutorialVideoScreen(
                title: t['title'],
                videoUrl: t['videoUrl'],
              ),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(14)),
              child: Image.asset(
                t['image'],
                height: 100,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    t['title'],
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.star, size: 14, color: Colors.amber),
                      const SizedBox(width: 4),
                      Text('${t['rating']}'),
                      const Spacer(),
                      const Icon(Icons.person, size: 14, color: Colors.black54),
                      const SizedBox(width: 4),
                      Text(
                        t['students'],
                        style: const TextStyle(
                            fontSize: 12, color: Colors.black54),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        toolbarHeight: 90,
        elevation: 0.5,
        title: const Text(
          'Search Tutorials',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: theme.colorScheme.surface,
        bottom: TabBar(
          controller: _tabController,
          labelColor: theme.colorScheme.primary,
          unselectedLabelColor: theme.colorScheme.onSurface.withOpacity(0.6),
          indicatorColor: theme.colorScheme.primary,
          tabs: const [
            Tab(text: 'Tutorials'),
            Tab(text: 'Books'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: GridView.builder(
              itemCount: tutorials.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 14,
                crossAxisSpacing: 14,
                childAspectRatio: 0.75,
              ),
              itemBuilder: (_, i) => buildCourseCard(tutorials[i]),
            ),
          ),
          const Center(child: Text('Books section coming soon 📚')),
        ],
      ),
    );
  }
}
