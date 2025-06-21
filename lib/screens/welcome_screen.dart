import 'package:flutter/material.dart';
import './LoginSreens/signup_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 🖼 Background Image
          SizedBox.expand(
            child: Image.asset(
              'assets/images/Books.jpeg',
              fit: BoxFit.cover,
            ),
          ),

          // 🔲 Overlay Color (optional for contrast)
          Container(
            color: Colors.black.withOpacity(0.3),
          ),

          // 📦 Main Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),

                  // 🟨 App Logo
                  Image.asset(
                    'assets/images/splashscreen.png',
                    height: 220,
                  ),

                  const SizedBox(height: 25),

                  // 👋 Welcome Text
                  const Text(
                    'Welcome to EasyLearning !!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 45,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(blurRadius: 10, color: Colors.black45),
                      ],
                    ),
                  ),

                  const SizedBox(height: 50),

                  // 📜 Subtitle
                  const Text(
                    'We are happy to have you here. EasyLearning accompanies in the preparation of your exams',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.white70,
                    ),
                  ),

                  const Spacer(),

                  // 👉 "Get Started" Button
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32.0, vertical: 40),
                    child: SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const SignUpScreen()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 3,
                        ),
                        child: const Text(
                          "Let's Get Started",
                          style: TextStyle(
                            fontSize: 25,
                            color: Colors.blueAccent,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 130),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
