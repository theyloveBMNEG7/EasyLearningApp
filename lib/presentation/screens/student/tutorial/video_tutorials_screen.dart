import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../data/models/tutorial_model.dart';
import '../../../widgets/common/video_player_screen.dart';

class VideoTutorialsScreen extends StatefulWidget {
  const VideoTutorialsScreen({super.key});

  @override
  State<VideoTutorialsScreen> createState() => _VideoTutorialsScreenState();
}

class _VideoTutorialsScreenState extends State<VideoTutorialsScreen> {
  String searchQuery = '';

  void _openVideoPlayer(String title, String videoUrl) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => VideoPlayerScreen(title: title, videoUrl: videoUrl),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // 🔍 Search Bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search tutorials...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) => setState(() => searchQuery = value),
            ),
          ),

          // 📺 Tutorial List
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('tutorials')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return const Center(child: CircularProgressIndicator());
                final tutorials = snapshot.data!.docs
                    .map((doc) => TutorialModel.fromMap(
                        doc.id, doc.data() as Map<String, dynamic>))
                    .where((tutorial) => tutorial.title
                        .toLowerCase()
                        .contains(searchQuery.toLowerCase()))
                    .toList();

                if (tutorials.isEmpty) {
                  return const Center(child: Text('No tutorials found.'));
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: tutorials.length,
                  itemBuilder: (context, index) {
                    final tutorial = tutorials[index];

                    return GestureDetector(
                      onTap: () =>
                          _openVideoPlayer(tutorial.title, tutorial.videoUrl),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 14),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: const [
                            BoxShadow(
                              blurRadius: 6,
                              offset: Offset(0, 3),
                              color: Colors.black12,
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: tutorial.thumbnailUrl != null &&
                                      tutorial.thumbnailUrl!.isNotEmpty
                                  ? Image.network(
                                      tutorial.thumbnailUrl!,
                                      width: 80,
                                      height: 60,
                                      fit: BoxFit.cover,
                                    )
                                  : Container(
                                      width: 80,
                                      height: 60,
                                      color: Colors.grey[300],
                                      child: const Icon(Icons.play_circle_fill,
                                          size: 40, color: Colors.grey),
                                    ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(tutorial.title,
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600)),
                                  Text(tutorial.subject,
                                      style: const TextStyle(
                                          fontSize: 13, color: Colors.grey)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
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
