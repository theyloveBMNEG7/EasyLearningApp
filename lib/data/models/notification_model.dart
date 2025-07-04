import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  final String id;
  final String title;
  final String message;
  final DateTime timestamp;

  NotificationModel(
      {required this.id,
      required this.title,
      required this.message,
      required this.timestamp});

  factory NotificationModel.fromMap(String id, Map<String, dynamic> data) =>
      NotificationModel(
        id: id,
        title: data['title'] ?? '',
        message: data['message'] ?? '',
        timestamp: (data['timestamp'] as Timestamp).toDate(),
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'message': message,
        'timestamp': Timestamp.fromDate(timestamp),
      };
}
