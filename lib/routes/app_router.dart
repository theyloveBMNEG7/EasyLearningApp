import 'package:flutter/material.dart';
import '../core/constants/routes.dart';
import '../presentation/screens/splash/splash_screen.dart';
import '../presentation/screens/onboarding/onboarding_screen.dart';
import '../presentation/screens/welcome/welcome_screen.dart';
import '../presentation/screens/auth/signin_screen.dart';
import '../presentation/screens/auth/signup_screen.dart';
import '../presentation/layouts/student/student_layout.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutePaths.splash:
        return _fadeRoute(const SplashScreen());

      case RoutePaths.onboarding:
        return _fadeRoute(const OnboardingScreen());

      case RoutePaths.welcome:
        return _fadeRoute(const WelcomeScreen());

      case RoutePaths.signin:
        return _fadeRoute(SigninScreen());

      case RoutePaths.signup:
        return _fadeRoute(const SignUpScreen());

      case RoutePaths.studentDashboard:
        return _fadeRoute(const StudentLayout());

      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Page not found')),
          ),
        );
    }
  }

  static PageRouteBuilder _fadeRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (_, animation, __, child) {
        return FadeTransition(opacity: animation, child: child);
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }
}
