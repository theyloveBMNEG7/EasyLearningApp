import 'package:cloud_firestore/cloud_firestore.dart';

class QuizLogModel {
  final String id;
  final String studentId;
  final String subject;
  final String topic;
  final int score;
  final int totalQuestions;
  final int durationSeconds;
  final List<Map<String, dynamic>> answers;
  final DateTime timestamp;

  QuizLogModel({
    required this.id,
    required this.studentId,
    required this.subject,
    required this.topic,
    required this.score,
    required this.totalQuestions,
    required this.durationSeconds,
    required this.answers,
    required this.timestamp,
  });

  factory QuizLogModel.fromMap(String id, Map<String, dynamic> data) {
    return QuizLogModel(
      id: id,
      studentId: data['studentId'] ?? '',
      subject: data['subject'] ?? '',
      topic: data['topic'] ?? '',
      score: data['score'] ?? 0,
      totalQuestions: data['totalQuestions'] ?? 0,
      durationSeconds: data['durationSeconds'] ?? 0,
      answers: List<Map<String, dynamic>>.from(data['answers'] ?? []),
      timestamp: (data['timestamp'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'studentId': studentId,
      'subject': subject,
      'topic': topic,
      'score': score,
      'totalQuestions': totalQuestions,
      'durationSeconds': durationSeconds,
      'answers': answers,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }
}
