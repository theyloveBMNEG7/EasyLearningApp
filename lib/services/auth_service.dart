import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../data/models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Register Student
  Future<AppUser?> registerStudent({
    required String fullName,
    required String email,
    required String password,
    required String examType,
    required String speciality,
    required String option,
  }) async {
    try {
      // 1. Create user with email & password
      final UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user == null) throw Exception('User creation failed');

      // 2. Create AppUser model
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

      // 3. Save user data to Firestore
      await _firestore.collection('users').doc(user.uid).set(newUser.toMap());

      return newUser;
    } on FirebaseAuthException catch (e) {
      print('FirebaseAuthException: ${e.code} - ${e.message}');
      throw Exception(e.message);
    } on FirebaseException catch (e) {
      print('FirebaseException: ${e.code} - ${e.message}');
      throw Exception(e.message);
    } catch (e) {
      print('Unknown error: $e');
      throw Exception('An unknown error occurred');
    }
  }

  // Teachers only login — no registration here
  Future<AppUser?> login({
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential cred = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      final doc =
          await _firestore.collection('users').doc(cred.user!.uid).get();

      if (!doc.exists) throw Exception('User data not found');

      final user = AppUser.fromMap(doc.data()!);

      return user;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  Future<AppUser?> getCurrentUser() async {
    final user = _auth.currentUser;
    if (user == null) return null;

    final doc = await _firestore.collection('users').doc(user.uid).get();
    if (!doc.exists) return null;

    return AppUser.fromMap(doc.data()!);
  }
}
