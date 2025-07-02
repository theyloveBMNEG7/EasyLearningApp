import 'package:flutter/material.dart';
import 'dart:async';

class AiQuizScreen extends StatefulWidget {
  const AiQuizScreen({super.key});

  @override
  State<AiQuizScreen> createState() => _AiQuizScreenState();
}

class _AiQuizScreenState extends State<AiQuizScreen> {
  // Simulated AI response: You would replace this with a backend call
  final List<Map<String, dynamic>> _questions = [
    {
      'question': 'Which language is used for Flutter development?',
      'options': ['Java', 'Swift', 'Dart', 'Kotlin'],
      'answer': 'Dart',
      'explanation': 'Flutter uses Dart, a modern language developed by Google.'
    },
    {
      'question': 'HTTP stands for?',
      'options': [
        'HyperText Transfer Protocol',
        'Hyperlink Transfer Protocol',
        'Host Transfer Protocol',
        'Hyperlink Text Protocol'
      ],
      'answer': 'HyperText Transfer Protocol',
      'explanation': 'HTTP is the protocol used for transmitting web pages.'
    }
  ];

  int _currentIndex = 0;
  String? _selectedOption;
  bool _answered = false;
  final Stopwatch _stopwatch = Stopwatch();
  String _answerFeedback = '';
  Color? _optionColor(String option) {
    if (!_answered) return null;
    if (option == _questions[_currentIndex]['answer']) {
      return Colors.green;
    }
    if (option == _selectedOption) return Colors.red;
    return null;
  }

  @override
  void initState() {
    super.initState();
    _stopwatch.start();
  }

  void _handleAnswer(String selected) {
    final current = _questions[_currentIndex];
    final isCorrect = selected == current['answer'];

    setState(() {
      _selectedOption = selected;
      _answered = true;
      _stopwatch.stop();
      //final timeTaken = _stopwatch.elapsed.inSeconds;

      _answerFeedback = isCorrect
          ? '✅ Correct! ${current['explanation']}'
          : '❌ Incorrect. ${current['explanation']}';

      // Wait before auto-advancing to next question
      Future.delayed(const Duration(seconds: 3), () {
        if (_currentIndex < _questions.length - 1) {
          setState(() {
            _currentIndex++;
            _selectedOption = null;
            _answered = false;
            _answerFeedback = '';
            _stopwatch.reset();
            _stopwatch.start();
          });
        } else {
          // You could show a result page here instead
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Quiz Complete!')),
          );
        }
      });
    });
  }

  @override
  void dispose() {
    _stopwatch.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final question = _questions[_currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text('AI-Powered Quiz'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Q${_currentIndex + 1}/${_questions.length}',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Text(
              question['question'],
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 24),
            ...question['options'].map<Widget>((option) {
              //final isTapped = option == _selectedOption;
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _optionColor(option),
                    padding: const EdgeInsets.symmetric(
                        vertical: 14, horizontal: 16),
                    textStyle: const TextStyle(fontSize: 14),
                  ),
                  onPressed: _answered ? null : () => _handleAnswer(option),
                  child: Row(
                    children: [
                      Expanded(child: Text(option)),
                      if (_answered && option == question['answer'])
                        const Icon(Icons.check_circle, color: Colors.white),
                      if (_answered &&
                          option == _selectedOption &&
                          option != question['answer'])
                        const Icon(Icons.cancel, color: Colors.white),
                    ],
                  ),
                ),
              );
            }).toList(),
            const SizedBox(height: 16),
            if (_answered)
              Text(
                _answerFeedback,
                style: const TextStyle(fontSize: 14.5, color: Colors.black87),
              ),
            const Spacer(),
            Text(
              '⏱ Time: ${_stopwatch.elapsed.inSeconds}s',
              style: const TextStyle(color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}
