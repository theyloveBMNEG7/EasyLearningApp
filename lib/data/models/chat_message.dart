class ChatMessage {
  final String id;
  final String sender;
  final String text;
  final DateTime timestamp;
  String? reaction;

  ChatMessage({
    required this.id,
    required this.sender,
    required this.text,
    required this.timestamp,
    this.reaction,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'sender': sender,
        'text': text,
        'timestamp': timestamp.toIso8601String(),
        'reaction': reaction,
      };

  factory ChatMessage.fromMap(Map<String, dynamic> map) => ChatMessage(
        id: map['id'],
        sender: map['sender'],
        text: map['text'],
        timestamp: DateTime.parse(map['timestamp']),
        reaction: map['reaction'],
      );
}
