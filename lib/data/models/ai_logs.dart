import 'package:cloud_firestore/cloud_firestore.dart';

class AiLogModel {
  final String id;
  final String userId;
  final String question;
  final String response;
  final DateTime timestamp;

  AiLogModel(
      {required this.id,
      required this.userId,
      required this.question,
      required this.response,
      required this.timestamp});

  factory AiLogModel.fromMap(String id, Map<String, dynamic> data) =>
      AiLogModel(
        id: id,
        userId: data['userId'] ?? '',
        question: data['question'] ?? '',
        response: data['response'] ?? '',
        timestamp: (data['timestamp'] as Timestamp).toDate(),
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'userId': userId,
        'question': question,
        'response': response,
        'timestamp': Timestamp.fromDate(timestamp),
      };
}
