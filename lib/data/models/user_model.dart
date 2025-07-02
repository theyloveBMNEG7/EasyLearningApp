import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  final String uid;
  final String email;
  final String role; // student | teacher | admin
  final String? displayName;
  final String? profilePictureUrl;
  final DateTime? createdAt;

  // Student-specific
  final String? examType;
  final String? speciality;
  final String? option;

  // Teacher-specific
  final String? mappedExamType;
  final String? mappedSpeciality;

  AppUser({
    required this.uid,
    required this.email,
    required this.role,
    this.displayName,
    this.profilePictureUrl,
    this.createdAt,
    this.examType,
    this.speciality,
    this.option,
    this.mappedExamType,
    this.mappedSpeciality,
  });

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      role: map['role'] ?? '',
      displayName: map['displayName'],
      profilePictureUrl: map['profilePictureUrl'],
      createdAt: map['createdAt'] is Timestamp
          ? (map['createdAt'] as Timestamp).toDate()
          : null,
      examType: map['examType'],
      speciality: map['speciality'],
      option: map['option'],
      mappedExamType: map['mappedExamType'],
      mappedSpeciality: map['mappedSpeciality'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'role': role,
      'displayName': displayName ?? '',
      'profilePictureUrl': profilePictureUrl ?? '',
      'createdAt':
          createdAt?.toIso8601String() ?? DateTime.now().toIso8601String(),
      'examType': examType ?? '',
      'speciality': speciality ?? '',
      'option': option ?? '',
      'mappedExamType': mappedExamType ?? '',
      'mappedSpeciality': mappedSpeciality ?? '',
    };
  }

  AppUser copyWith({
    String? uid,
    String? email,
    String? role,
    String? displayName,
    String? profilePictureUrl,
    DateTime? createdAt,
    String? examType,
    String? speciality,
    String? option,
    String? mappedExamType,
    String? mappedSpeciality,
  }) {
    return AppUser(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      role: role ?? this.role,
      displayName: displayName ?? this.displayName,
      profilePictureUrl: profilePictureUrl ?? this.profilePictureUrl,
      createdAt: createdAt ?? this.createdAt,
      examType: examType ?? this.examType,
      speciality: speciality ?? this.speciality,
      option: option ?? this.option,
      mappedExamType: mappedExamType ?? this.mappedExamType,
      mappedSpeciality: mappedSpeciality ?? this.mappedSpeciality,
    );
  }
}
