import 'package:flutter/material.dart';
import 'routes/app_router.dart';
import 'core/constants/routes.dart';

class EasyLearningApp extends StatelessWidget {
  const EasyLearningApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EasyLearning',
      initialRoute: RoutePaths.splash,
      onGenerateRoute: AppRouter.generateRoute,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          primary: Colors.blue,
          secondary: Colors.lightBlueAccent,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF5F7FA),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          elevation: 2,
        ),
        textTheme: const TextTheme(
          titleLarge: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
