import 'package:flutter/material.dart';
import 'ai_quiz_screen.dart';
import 'realtime_quiz_screen.dart';

class QuizScreen extends StatelessWidget {
  const QuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Quizzes',
          style: TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.w900,
              fontSize: 25,
              fontFamily: 'OpenSans'),
        ),
        centerTitle: true,
        backgroundColor: theme.colorScheme.surface,
        elevation: 0.6,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 18),
            const Text(
              'Choose your preferred quiz style',
              style: TextStyle(
                  fontSize: 21, color: Colors.black87, fontFamily: 'OpenSans'),
            ),
            const SizedBox(height: 45),

            // Real-time Quiz
            _QuizModeCard(
              icon: Icons.timer_outlined,
              title: 'Real-time Quiz',
              color: Colors.indigo,
              accent: Colors.indigoAccent,
              description:
                  'Experience exam pressure with timed mock questions.',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const RealtimeQuizScreen()),
                );
              },
            ),
            const SizedBox(height: 24),

            // AI Quiz
            _QuizModeCard(
              icon: Icons.auto_awesome_rounded,
              title: 'AI-Powered Quiz',
              color: Colors.blue,
              accent: Colors.blueAccent,
              description:
                  'Smart quizzes tailored to your strengths and knowledge gaps.',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AiQuizScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _QuizModeCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Color color;
  final Color accent;
  final VoidCallback onTap;

  const _QuizModeCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
    required this.accent,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        color: color.withOpacity(0.09),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: accent.withOpacity(0.5)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 18),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: accent.withOpacity(0.15),
                  child: Icon(icon, color: color, size: 28),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 17,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        description,
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_ios_rounded,
                    size: 16, color: Colors.black45),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
