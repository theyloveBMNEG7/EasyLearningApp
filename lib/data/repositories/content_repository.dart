import '../models/tutorial_model.dart';

class ContentRepository {
  Future<List<Tutorial>> fetchAllTutorials() async {
    // Replace with API integration
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      Tutorial(
        id: '1',
        title: 'Getting Started with Flutter',
        videoUrl: 'https://example.com/flutter_intro.mp4',
        image: 'assets/images/flutter.jpg',
        type: 'uploaded',
        description: 'Learn the basics of Flutter and Dart.',
      ),
      // Add more mock tutorials here
    ];
  }
}
