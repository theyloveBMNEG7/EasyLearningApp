import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Uncomment when needed for development reset
import 'app.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'services/user_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  const bool isDebugMode = bool.fromEnvironment('dart.vm.product') == false;
  if (isDebugMode) {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasSeenIntro', false);
    await prefs.setBool('isLoggedIn', false);
  }

  runApp(
    DevicePreview(
      builder: (context) => MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => UserProvider()),
        ],
        child: const EasyLearningApp(),
      ),
    ),
  );
}
