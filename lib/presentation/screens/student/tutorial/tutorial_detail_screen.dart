import 'package:flutter/material.dart';
import '../../../../data/models/tutorial_model.dart';
import '../../../widgets/common/uploaded_video_player.dart';

class TutorialDetailScreen extends StatelessWidget {
  final Tutorial tutorial;

  const TutorialDetailScreen({super.key, required this.tutorial});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const int completed = 3;
    const int total = 10;
    final progress = completed / total;

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        elevation: 0.3,
        centerTitle: true,
        title: Text(
          tutorial.title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: const BackButton(color: Colors.black),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: Icon(Icons.more_vert, color: Colors.black54),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Preview video
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => UploadedVideoPlayer(
                      title: tutorial.title,
                      videoUrl: tutorial.videoUrl,
                    ),
                  ),
                );
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  AspectRatio(
                    aspectRatio: 16 / 9,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                          bottom: Radius.circular(14)),
                      child: Image.asset(
                        tutorial.image,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.black45,
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(8),
                    child: const Icon(Icons.play_arrow,
                        size: 48, color: Colors.white),
                  ),
                ],
              ),
            ),

            // Progress section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$completed of $total lessons completed',
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 8,
                      backgroundColor: Colors.grey[300],
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 4),
              child: Text(
                'Lessons',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),

            // Lessons list
            Expanded(
              child: ListView.separated(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                itemCount: total,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (_, index) {
                  return Card(
                    elevation: 0.3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 10),
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          tutorial.image,
                          width: 80,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                      ),
                      title: Text(
                        'Lesson #${index + 1}: Topic name',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      subtitle: Text(
                        'Admin • ${300 + index * 200} views • ${index + 2} days ago',
                        style: theme.textTheme.bodySmall,
                      ),
                      trailing:
                          const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                      onTap: () {
                        // TODO: Handle individual lesson play (if added)
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
