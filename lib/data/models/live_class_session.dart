import 'package:cloud_firestore/cloud_firestore.dart';

class LiveClassModel {
  final String id;
  final String teacherId;
  final String teacherName;
  final String subject;
  final String level;
  final String department;
  final String startTime; // e.g. "10:00 AM"
  final String endTime; // e.g. "11:30 AM"
  final String status; // "Live", "Upcoming", "Ended"
  final List<String> participants; // List of student UIDs
  final DateTime createdAt;

  LiveClassModel({
    required this.id,
    required this.teacherId,
    required this.teacherName,
    required this.subject,
    required this.level,
    required this.department,
    required this.startTime,
    required this.endTime,
    required this.status,
    required this.participants,
    required this.createdAt,
  });

  factory LiveClassModel.fromMap(String id, Map<String, dynamic> data) {
    return LiveClassModel(
      id: id,
      teacherId: data['teacherId'] ?? '',
      teacherName: data['teacherName'] ?? '',
      subject: data['subject'] ?? '',
      level: data['level'] ?? '',
      department: data['department'] ?? '',
      startTime: data['startTime'] ?? '',
      endTime: data['endTime'] ?? '',
      status: data['status'] ?? 'Upcoming',
      participants: List<String>.from(data['participants'] ?? []),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'teacherId': teacherId,
      'teacherName': teacherName,
      'subject': subject,
      'level': level,
      'department': department,
      'startTime': startTime,
      'endTime': endTime,
      'status': status,
      'participants': participants,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
