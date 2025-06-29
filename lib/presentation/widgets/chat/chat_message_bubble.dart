import 'package:flutter/material.dart';
import '../../../data/models/chat_message.dart';

class ChatMessageBubble extends StatelessWidget {
  final ChatMessage message;
  final bool isMe;
  final VoidCallback onLongPress;

  const ChatMessageBubble({
    super.key,
    required this.message,
    required this.isMe,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final timeLabel = TimeOfDay.fromDateTime(message.timestamp).format(context);

    return GestureDetector(
      onLongPress: onLongPress,
      child: Align(
        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 6),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
          constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.65),
          decoration: BoxDecoration(
            color: isMe ? Colors.blueAccent : Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(16),
              topRight: const Radius.circular(16),
              bottomLeft:
                  isMe ? const Radius.circular(16) : const Radius.circular(0),
              bottomRight:
                  isMe ? const Radius.circular(0) : const Radius.circular(16),
            ),
            boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6)],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!isMe)
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    message.sender,
                    style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.black54),
                  ),
                ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Flexible(
                    child: Text(
                      message.text,
                      style: TextStyle(
                        color: isMe ? Colors.white : Colors.black87,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    timeLabel,
                    style: TextStyle(
                        fontSize: 11,
                        color: isMe ? Colors.white70 : Colors.black45),
                  ),
                  if (isMe)
                    const Padding(
                      padding: EdgeInsets.only(left: 4.0),
                      child: Icon(Icons.done_rounded,
                          size: 16, color: Colors.white70),
                    ),
                ],
              ),
              if (message.reaction != null)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(message.reaction!,
                      style: const TextStyle(fontSize: 18)),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
