import 'package:cloud_firestore/cloud_firestore.dart';

class CorrectionModel {
  final String? id;
  final String title;
  final String description;
  final String subject;
  final String level;
  final String pdfUrl;
  final String teacherId;
  final DateTime createdAt;

  CorrectionModel({
    this.id,
    required this.title,
    required this.description,
    required this.subject,
    required this.level,
    required this.pdfUrl,
    required this.teacherId,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'subject': subject,
      'level': level,
      'pdfUrl': pdfUrl,
      'teacherId': teacherId,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory CorrectionModel.fromMap(String id, Map<String, dynamic> data) {
    return CorrectionModel(
      id: id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      subject: data['subject'] ?? '',
      level: data['level'] ?? '',
      pdfUrl: data['pdfUrl'] ?? '',
      teacherId: data['teacherId'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }
}
