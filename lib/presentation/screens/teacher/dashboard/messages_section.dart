import 'package:flutter/material.dart';

class MessagesSection extends StatelessWidget {
  const MessagesSection({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy messages
    final messages = [
      {
        'from': 'Admin',
        'content': 'New policy updates available.',
        'date': 'Today'
      },
      {
        'from': 'Student John',
        'content': 'Question about assignment.',
        'date': 'Yesterday'
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Messages",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: messages.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final message = messages[index];
            return ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.blue.shade300,
                child: Text(message['from']![0]),
              ),
              title: Text(message['from']!),
              subtitle: Text(message['content']!),
              trailing: Text(
                message['date']!,
                style: const TextStyle(color: Colors.grey),
              ),
              onTap: () {
                // Open message thread or details
              },
            );
          },
        ),
      ],
    );
  }
}
