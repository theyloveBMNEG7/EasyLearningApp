import 'package:cloud_firestore/cloud_firestore.dart';

class TutorialModel {
  final String? id;
  final String title;
  final String description;
  final String subject;
  final String level;
  final String videoUrl;
  final String? thumbnailUrl;
  final String teacherId;
  final DateTime createdAt;

  TutorialModel({
    this.id,
    required this.title,
    required this.description,
    required this.subject,
    required this.level,
    required this.videoUrl,
    this.thumbnailUrl,
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
      'videoUrl': videoUrl,
      'thumbnailUrl': thumbnailUrl ?? '',
      'teacherId': teacherId,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory TutorialModel.fromMap(String id, Map<String, dynamic> data) {
    return TutorialModel(
      id: id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      subject: data['subject'] ?? '',
      level: data['level'] ?? '',
      videoUrl: data['videoUrl'] ?? '',
      thumbnailUrl: data['thumbnailUrl'],
      teacherId: data['teacherId'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }
}
