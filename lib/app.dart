import 'package:flutter/material.dart';
import 'routes/app_router.dart';
//import 'core/constants/routes.dart';
import 'presentation/screens/splash/splash_screen.dart';

class EasyLearningApp extends StatelessWidget {
  const EasyLearningApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EasyLearning',
      home: const SplashScreen(),
      onGenerateRoute: AppRouter.generateRoute,
      debugShowCheckedModeBanner: false,
    );
  }
}
