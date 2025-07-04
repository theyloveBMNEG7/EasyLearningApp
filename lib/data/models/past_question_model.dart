import 'package:cloud_firestore/cloud_firestore.dart';

class PastQuestionModel {
  final String id;
  final String title;
  final String subject;
  final String pdfUrl;
  final DateTime createdAt;

  PastQuestionModel({
    required this.id,
    required this.title,
    required this.subject,
    required this.pdfUrl,
    required this.createdAt,
  });

  factory PastQuestionModel.fromMap(String id, Map<String, dynamic> data) {
    return PastQuestionModel(
      id: id,
      title: data['title'] ?? '',
      subject: data['subject'] ?? '',
      pdfUrl: data['pdfUrl'] ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'subject': subject,
      'pdfUrl': pdfUrl,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
