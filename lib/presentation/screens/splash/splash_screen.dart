import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constants/routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late Animation<double> _logoAnimation;

  late AnimationController _textController;
  late Animation<double> _textAnimation;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _checkFirstTimeUser();
  }

  void _initAnimations() {
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _logoAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeOut),
    );

    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    );
    _textAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeIn),
    );

    _logoController.forward();
    _textController.forward();
  }

  Future<void> _checkFirstTimeUser() async {
    final prefs = await SharedPreferences.getInstance();
    final hasSeenIntro = prefs.getBool('hasSeenIntro') ?? false;
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    Timer(const Duration(seconds: 3), () {
      if (isLoggedIn) {
        Navigator.pushReplacementNamed(context, RoutePaths.studentDashboard);
      } else if (!hasSeenIntro) {
        Navigator.pushReplacementNamed(context, RoutePaths.onboarding);
      } else {
        Navigator.pushReplacementNamed(context, RoutePaths.welcome);
      }
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FadeTransition(
                opacity: _logoAnimation,
                child: ScaleTransition(
                  scale: _logoAnimation,
                  child: Image.asset(
                    'assets/images/splashscreen.png',
                    height: 230,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              FadeTransition(
                opacity: _textAnimation,
                child: const Text(
                  'EasyLearning',
                  style: TextStyle(
                    fontSize: 50,
                    fontFamily: 'ComicRelief',
                    fontWeight: FontWeight.bold,
                    color: Colors.lightBlue,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              const CircularProgressIndicator(color: Colors.blueAccent),
            ],
          ),
        ),
      ),
    );
  }
}
