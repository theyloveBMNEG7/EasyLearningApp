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

  Widget buildCourseCard(Map<String, dynamic> tutorial) {
    return Material(
      borderRadius: BorderRadius.circular(16),
      color: Colors.white,
      elevation: 3,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => TutorialVideoScreen(
                title: tutorial['title'],
                videoUrl: tutorial['videoUrl'],
              ),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail
            SizedBox(
              height: 110,
              width: double.infinity,
              child: Image.asset(
                tutorial['image'],
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
                    tutorial['title'],
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      // Star rating
                      Icon(Icons.star, size: 14, color: Colors.amber[700]),
                      const SizedBox(width: 4),
                      Text(
                        tutorial['rating'].toString(),
                        style: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w500),
                      ),
                      const Spacer(),
                      Icon(Icons.person, size: 14, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        tutorial['students'],
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
      backgroundColor: const Color(0xFFF4F6FA),
      appBar: AppBar(
        toolbarHeight: 90,
        elevation: 1,
        title: const Text(
          'Search Tutorials',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
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
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: GridView.builder(
              itemCount: tutorials.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.75,
              ),
              itemBuilder: (_, i) => buildCourseCard(tutorials[i]),
            ),
          ),
          const Center(
            child: Text(
              '📚 Books section coming soon!',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}
