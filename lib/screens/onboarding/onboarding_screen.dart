import 'package:flutter/material.dart';
import '../../models/onboarding_model.dart';
import 'widgets/onboarding_page.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingModel> _pages = [
    OnboardingModel(
      image: 'assets/images/onboarding1.png',
      title: 'Learn Anywhere, Anytime',
      description: 'Study smart with AI-powered personalized guidance.',
    ),
    OnboardingModel(
      image: 'assets/images/onboarding2.png',
      title: 'Track Your Progress',
      description: 'Monitor your scores and understand your strengths.',
    ),
    OnboardingModel(
      image: 'assets/images/onboarding3.png',
      title: 'Ace Your Exams',
      description: 'Focus on weak topics and boost your confidence.',
    ),
  ];

  void _onNext() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    } else {
      // Navigate to Login or Home Screen
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        controller: _pageController,
        itemCount: _pages.length,
        onPageChanged: (index) => setState(() => _currentPage = index),
        itemBuilder: (context, index) {
          return OnboardingPage(
            image: _pages[index].image,
            title: _pages[index].title,
            description: _pages[index].description,
          );
        },
      ),
      bottomSheet: Container(
        height: 70,
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () =>
                  Navigator.pushReplacementNamed(context, '/login'),
              child: const Text('Skip'),
            ),
            Row(
              children: List.generate(
                _pages.length,
                (index) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _currentPage == index ? 16 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _currentPage == index ? Colors.blue : Colors.grey,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: _onNext,
              child: Text(_currentPage == _pages.length - 1 ? 'Start' : 'Next'),
            ),
          ],
        ),
      ),
    );
  }
}
