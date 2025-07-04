import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../data/models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 🔹 Register Student
  Future<AppUser?> registerStudent({
    required String fullName,
    required String email,
    required String password,
    required String examType,
    required String speciality,
    required String option,
  }) async {
    final UserCredential userCredential =
        await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = userCredential.user;
    if (user == null) throw Exception('User creation failed');

    final AppUser newUser = AppUser(
      uid: user.uid,
      email: email,
      displayName: fullName,
      role: 'student',
      examType: examType,
      speciality: speciality,
      option: option,
      profilePictureUrl: null,
      createdAt: DateTime.now(),
    );

    await _firestore.collection('users').doc(user.uid).set(newUser.toMap());

    return newUser;
  }

  // 🔹 Login for all roles
  Future<AppUser?> login({
    required String email,
    required String password,
  }) async {
    final UserCredential cred = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final doc = await _firestore.collection('users').doc(cred.user!.uid).get();
    if (!doc.exists) throw Exception('User data not found');

    final user = AppUser.fromMap(doc.data()!);
    return user;
  }

  // 🔹 Admin creates teacher
  Future<void> createTeacher({
    required String uid,
    required String email,
    required String displayName,
    required String mappedExamType,
    required String mappedSpeciality,
  }) async {
    final AppUser teacher = AppUser(
      uid: uid,
      email: email,
      role: 'teacher',
      displayName: displayName,
      profilePictureUrl: null,
      createdAt: DateTime.now(),
      mappedExamType: mappedExamType,
      mappedSpeciality: mappedSpeciality,
    );

    await _firestore.collection('users').doc(uid).set(teacher.toMap());
  }

  // 🔹 Logout
  Future<void> logout() async {
    await _auth.signOut();
  }

  // 🔹 Get current user
  Future<AppUser?> getCurrentUser() async {
    final user = _auth.currentUser;
    if (user == null) return null;

    final doc = await _firestore.collection('users').doc(user.uid).get();
    if (!doc.exists) return null;

    return AppUser.fromMap(doc.data()!);
  }

  // 🔹 Optional: Auth state stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();
}
