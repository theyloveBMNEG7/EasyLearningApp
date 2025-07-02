import 'package:flutter/material.dart';
import 'dart:async';

class RealtimeQuizScreen extends StatefulWidget {
  const RealtimeQuizScreen({super.key});

  @override
  State<RealtimeQuizScreen> createState() => _RealtimeQuizScreenState();
}

class _RealtimeQuizScreenState extends State<RealtimeQuizScreen> {
  final List<Map<String, dynamic>> _questions = [
    {
      'question': 'What is 7 × 6?',
      'options': ['42', '36', '48', '56'],
      'answer': '42',
      'explanation': '7 multiplied by 6 is 42.'
    },
    {
      'question': 'What is the capital of Cameroon?',
      'options': ['Yaoundé', 'Douala', 'Bamenda', 'Kribi'],
      'answer': 'Yaoundé',
      'explanation': 'Yaoundé is the political capital of Cameroon.'
    }
  ];

  int _currentIndex = 0;
  String? _selectedOption;
  bool _answered = false;
  final Stopwatch _stopwatch = Stopwatch();
  String _answerFeedback = '';

  Color? _optionColor(String option) {
    if (!_answered) return null;
    if (option == _questions[_currentIndex]['answer']) return Colors.green;
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
    //final timeTaken = _stopwatch.elapsed.inSeconds;

    setState(() {
      _selectedOption = selected;
      _answered = true;
      _stopwatch.stop();

      _answerFeedback = isCorrect
          ? '✅ Correct! ${current['explanation']}'
          : '❌ Incorrect. ${current['explanation']}';

      // Advance to next question after a delay
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
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('You’ve completed the quiz!')),
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
        title: const Text('Real-time Quiz'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Q${_currentIndex + 1}/${_questions.length}',
                style: const TextStyle(fontSize: 14, color: Colors.grey)),
            const SizedBox(height: 8),
            Text(
              question['question'],
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 24),
            ...question['options'].map<Widget>((option) {
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
