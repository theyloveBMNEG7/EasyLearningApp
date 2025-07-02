// lib/presentation/screens/teacher/models/message.dart
class Message {
  final String id;
  final String senderName;
  final String contentPreview;
  final DateTime receivedAt;

  Message({
    required this.id,
    required this.senderName,
    required this.contentPreview,
    required this.receivedAt,
  });
}
