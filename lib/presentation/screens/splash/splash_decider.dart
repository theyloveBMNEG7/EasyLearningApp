import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../presentation/screens/welcome/welcome_screen.dart';
import 'package:easylearningapp/presentation/screens/onboarding/onboarding_screen.dart';
import '../../../presentation/layouts/student/student_layout.dart';
import '../../../presentation/layouts/teacher_layout.dart';
import '../../../presentation/screens/admin/admin_dashboard.dart';
import '../../../services/auth_service.dart';

class SplashDecider extends StatelessWidget {
  const SplashDecider({super.key});

  Future<Widget> _determineStartScreen() async {
    final prefs = await SharedPreferences.getInstance();
    final hasSeenIntro = prefs.getBool('hasSeenIntro') ?? false;

    // Check Firebase Auth state instead of SharedPreferences
    final authService = AuthService();
    final currentUser = await authService.getCurrentUser();

    if (currentUser != null) {
      // User is authenticated, route based on role
      switch (currentUser.role) {
        case 'student':
          return const StudentLayout();
        case 'teacher':
          return const TeacherLayout();
        case 'admin':
          return const AdminDashboard();
        default:
          // Unknown role, logout and go to welcome
          await authService.logout();
          await prefs.setBool('isLoggedIn', false);
          return const WelcomeScreen();
      }
    }

    // User not authenticated
    if (!hasSeenIntro) return const OnboardingScreen();
    return const WelcomeScreen();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: _determineStartScreen(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Loading...', style: TextStyle(fontSize: 16)),
                ],
              ),
            ),
          );
        }

        if (snapshot.hasError) {
          return const Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error, size: 48, color: Colors.red),
                  SizedBox(height: 16),
                  Text('Something went wrong. Please restart the app.'),
                ],
              ),
            ),
          );
        }

        return snapshot.data ?? const WelcomeScreen();
      },
    );
  }
}
