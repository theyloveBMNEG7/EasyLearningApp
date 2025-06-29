import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../presentation/screens/auth/signin_screen.dart';
import '../../../presentation/screens/welcome/welcome_screen.dart';
import 'package:easylearningapp/presentation/screens/onboarding/onboarding_screen.dart';
import '../../../presentation/layouts/student/student_layout.dart';

class SplashDecider extends StatelessWidget {
  const SplashDecider({super.key});

  Future<Widget> _determineStartScreen() async {
    final prefs = await SharedPreferences.getInstance();
    final hasSeenIntro = prefs.getBool('hasSeenIntro') ?? false;
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (isLoggedIn) return const StudentLayout();
    if (!hasSeenIntro) return const OnboardingScreen();
    return const WelcomeScreen();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: _determineStartScreen(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        return snapshot.data!;
      },
    );
  }
}
