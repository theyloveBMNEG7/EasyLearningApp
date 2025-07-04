import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../data/models/user_model.dart';

class UserProvider with ChangeNotifier {
  AppUser? _user;
  AppUser? get user => _user;

  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  Future<void> loadUser() async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) return;

    final doc = await _firestore.collection('users').doc(currentUser.uid).get();
    if (doc.exists) {
      _user = AppUser.fromMap(doc.data()!);
      notifyListeners();
    }
  }

  void clearUser() {
    _user = null;
    notifyListeners();
  }
}
