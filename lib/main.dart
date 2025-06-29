import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool('hasSeenIntro', true);
  await prefs.setBool('isLoggedIn', true);
  runApp(const EasyLearningApp());
}
