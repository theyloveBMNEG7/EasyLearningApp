import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
//import '../auth/signup_screen.dart';
import '../welcome/welcome_screen.dart';
import 'onboarding_data.dart';
import 'onboarding_widget.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  bool onLastPage = false;

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_shown', true);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const WelcomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _controller,
            itemCount: onboardingPages.length,
            onPageChanged: (index) {
              setState(() => onLastPage = index == onboardingPages.length - 1);
            },
            itemBuilder: (_, i) => OnboardingWidget(
              content: onboardingPages[i],
              onNext: () {
                if (onLastPage) {
                  _completeOnboarding();
                } else {
                  _controller.nextPage(
                    duration: const Duration(milliseconds: 800),
                    curve: Curves.ease,
                  );
                }
              },
            ),
          ),

          // 🔹 Skip button
          Positioned(
            top: 40,
            right: 20,
            child: TextButton(
              onPressed: _completeOnboarding,
              style: TextButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                backgroundColor: Colors.black26,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text('Skip'),
            ),
          ),

          // 🔸 Dots indicator
          Positioned(
            bottom: 40,
            left: 20,
            child: SmoothPageIndicator(
              controller: _controller,
              count: onboardingPages.length,
              effect: const ExpandingDotsEffect(
                dotHeight: 10,
                dotWidth: 10,
                spacing: 6,
                activeDotColor: Colors.blueAccent,
                dotColor: Colors.grey,
              ),
            ),
          ),

          // 🔸 Next button
          Positioned(
            bottom: 25,
            right: 20,
            child: FloatingActionButton(
              backgroundColor: Colors.blue,
              shape: const CircleBorder(),
              child: const Icon(
                Icons.arrow_forward_ios,
                color: Colors.white,
                size: 25,
              ),
              onPressed: () {
                if (onLastPage) {
                  _completeOnboarding();
                } else {
                  _controller.nextPage(
                    duration: const Duration(milliseconds: 800),
                    curve: Curves.ease,
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
