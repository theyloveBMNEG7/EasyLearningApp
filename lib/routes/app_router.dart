import 'package:flutter/material.dart';

import '../core/constants/routes.dart';
import '../presentation/screens/splash/splash_screen.dart';
import '../presentation/screens/onboarding/onboarding_screen.dart';
import '../presentation/screens/welcome/welcome_screen.dart';
import '../presentation/screens/auth/signin_screen.dart';
import '../presentation/screens/auth/signup_screen.dart';
import '../presentation/layouts/student/student_layout.dart';
import '../presentation/layouts/teacher_layout.dart';
import '../presentation/screens/teacher/live class/host_class_screen.dart';
import '../presentation/screens/teacher/live class/schedule_class_screen.dart';
import '../presentation/screens//student/live_class/join_live_class_screen.dart';
import '../presentation/screens/admin/admin_class_monitor.dart';
import '../presentation/screens/notifications/notification_screen.dart';
//import '../presentation/layouts/admin/admin_layout.dart';

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

      case RoutePaths.teacherDashboard:
        return _fadeRoute(const TeacherLayout());
      case RoutePaths.scheduleClass:
        return _fadeRoute(const ScheduleClassScreen());

      case RoutePaths.teacherUpload:
        return _fadeRoute(const TeacherLayout(initialIndex: 1));

      case RoutePaths.hostClass:
        return _fadeRoute(const HostClassScreen());

      case RoutePaths.joinLiveClass:
        return _fadeRoute(const JoinLiveClassScreen());

      case '/notifications':
        final args = settings.arguments as Map<String, dynamic>;
        return _fadeRoute(NotificationScreen(
          userRole: args['userRole'],
          userId: args['userId'],
        ));

      case RoutePaths.adminDashboard:
      //  return _fadeRoute(const AdminLayout());
      case RoutePaths.adminMonitorClass:
        return _fadeRoute(const AdminClassMonitorScreen());

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
