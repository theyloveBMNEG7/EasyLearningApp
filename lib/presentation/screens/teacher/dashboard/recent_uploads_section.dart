import 'package:flutter/material.dart';

class RecentUploadsSection extends StatelessWidget {
  const RecentUploadsSection({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy list of uploads
    final uploads = [
      {
        'title': 'Data Structures Basics',
        'type': 'Course',
        'date': '2025-06-29'
      },
      {
        'title': 'Sorting Algorithms',
        'type': 'Correction',
        'date': '2025-06-28'
      },
      {
        'title': 'Flutter Widgets Tutorial',
        'type': 'Tutorial',
        'date': '2025-06-27'
      },
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(top: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Recent Uploads",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'OpenSans',
            ),
          ),
          const SizedBox(height: 12),
          ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: uploads.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final upload = uploads[index];
              return ListTile(
                leading: _uploadIcon(upload['type']!),
                title: Text(
                  upload['title']!,
                  style: const TextStyle(
                    fontFamily: 'OpenSans',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(
                  'Type: ${upload['type']}',
                  style: const TextStyle(fontFamily: 'OpenSans'),
                ),
                trailing: Text(
                  upload['date']!,
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
                onTap: () {
                  // Optional: Navigate to details or edit screen
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _uploadIcon(String type) {
    switch (type.toLowerCase()) {
      case 'course':
        return const Icon(Icons.book, color: Colors.blue);
      case 'correction':
        return const Icon(Icons.file_copy, color: Colors.orange);
      case 'tutorial':
        return const Icon(Icons.video_library, color: Colors.green);
      default:
        return const Icon(Icons.insert_drive_file);
    }
  }
}
