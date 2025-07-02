import 'package:flutter/material.dart';

class TopicVideosScreen extends StatelessWidget {
  final String topic;

  const TopicVideosScreen({super.key, required this.topic});

  @override
  Widget build(BuildContext context) {
    final videos = [
      {
        'title': '#1: Introduction to $topic',
        'publisher': 'Programiz',
        'views': '5k views',
        'time': '3 weeks ago',
        'thumbnail': 'assets/images/c_thumbnail.jpg',
      },
      {
        'title': '#2: Deep Dive into $topic',
        'publisher': 'Programiz',
        'views': '3k views',
        'time': '2 weeks ago',
        'thumbnail': 'assets/images/c_thumbnail.jpg',
      },
    ];

    return Scaffold(
      appBar: AppBar(title: Text(topic)),
      body: Column(
        children: [
          Container(
            height: 200,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/c_thumbnail.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: const Center(
              child:
                  Icon(Icons.play_circle_fill, size: 64, color: Colors.white),
            ),
          ),
          const SizedBox(height: 16),
          const TabBar(
            tabs: [
              Tab(text: 'Course'),
              Tab(text: 'Resources'),
              Tab(text: 'More'),
            ],
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: videos.length,
              itemBuilder: (context, index) {
                final video = videos[index];
                return ListTile(
                  leading: Image.asset(video['thumbnail']!, width: 60),
                  title: Text(video['title']!),
                  subtitle: Text(
                      '${video['publisher']} • ${video['views']} • ${video['time']}'),
                  onTap: () {
                    // TODO: Navigate to video player
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
