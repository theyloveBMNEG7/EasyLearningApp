import 'package:cloud_firestore/cloud_firestore.dart';

class BookModel {
  final String id;
  final String title;
  final String description;
  final String level;
  final String pdfUrl;
  final String teacherId;
  final DateTime createdAt;

  BookModel({
    required this.id,
    required this.title,
    required this.description,
    required this.level,
    required this.pdfUrl,
    required this.teacherId,
    required this.createdAt,
  });

  factory BookModel.fromMap(String id, Map<String, dynamic> data) {
    return BookModel(
      id: id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      level: data['level'] ?? '',
      pdfUrl: data['pdfUrl'] ?? '',
      teacherId: data['teacherId'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'level': level,
      'pdfUrl': pdfUrl,
      'teacherId': teacherId,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
