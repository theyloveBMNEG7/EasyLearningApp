import '../presentation/screens/splash/splash_screen.dart';
import '../presentation/screens/onboarding/onboarding_screen.dart';
import '../presentation/screens/welcome/welcome_screen.dart';
import '../presentation/screens/auth/signin_screen.dart';
import '../presentation/screens/auth/signup_screen.dart';
import 'package:flutter/material.dart';
import '../core/constants/routes.dart';
import '../presentation/layouts/student/student_layout.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutePaths.splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case RoutePaths.onboarding:
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());
      case RoutePaths.welcome:
        return MaterialPageRoute(builder: (_) => const WelcomeScreen());
      case RoutePaths.signin:
        return MaterialPageRoute(builder: (_) => const SigninScreen());
      case RoutePaths.signup:
        return MaterialPageRoute(builder: (_) => const SignUpScreen());
      case RoutePaths.studentDashboard:
        return MaterialPageRoute(builder: (_) => const StudentLayout());

      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Page not found')),
          ),
        );
    }
  }
}
