import 'package:flutter/material.dart';

class ChatReactionPicker extends StatelessWidget {
  final void Function(String emoji) onSelect;

  const ChatReactionPicker({super.key, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    final emojis = ['👍', '❤️', '😂', '😮', '😢', '👏'];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: emojis.map((emoji) {
          return GestureDetector(
            onTap: () => onSelect(emoji),
            child: Text(emoji, style: const TextStyle(fontSize: 28)),
          );
        }).toList(),
      ),
    );
  }
}
