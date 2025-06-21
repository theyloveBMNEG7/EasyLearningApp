import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../welcome_screen.dart';
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
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (_) => WelcomeScreen()));
                } else {
                  _controller.nextPage(
                    duration: const Duration(milliseconds: 800),
                    curve: Curves.ease,
                  );
                }
              },
            ),
          ),

          // 🔹 Skip button at top-right
          Positioned(
            top: 25,
            right: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 2),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 202, 202, 202),
                borderRadius: BorderRadius.circular(60),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 5,
                    offset: Offset(1, 2),
                  ),
                ],
              ),
              child: TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => WelcomeScreen()),
                  );
                },
                child: const Text(
                  "Skip",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ),
          // Page indicator
          Positioned(
            bottom: 40,
            left: 20,
            child: SmoothPageIndicator(
              controller: _controller,
              count: onboardingPages.length,
              effect: const ExpandingDotsEffect(
                dotColor: Colors.grey,
                activeDotColor: Colors.blue,
              ),
            ),
          ),

          // Next button
          Positioned(
            bottom: 30,
            right: 20,
            child: FloatingActionButton(
              backgroundColor: Colors.blue,
              shape: const CircleBorder(),
              child: const Icon(
                Icons.arrow_forward_ios,
                color: Colors.white,
              ),
              onPressed: () {
                if (onLastPage) {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (_) => WelcomeScreen()));
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
