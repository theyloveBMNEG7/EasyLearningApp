import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

class RealtimeQuizScreen extends StatefulWidget {
  const RealtimeQuizScreen({super.key});

  @override
  State<RealtimeQuizScreen> createState() => _RealtimeQuizScreenState();
}

class _RealtimeQuizScreenState extends State<RealtimeQuizScreen> {
  List<Map<String, dynamic>> _questions = [];
  int _currentIndex = 0;
  String? _selectedLabel;
  bool _answered = false;
  String _answerFeedback = '';
  String _explanationText = '';
  Timer? _timer;
  double _timeLeft = 1.0;
  static const int _maxTime = 45;

  final List<String> _labels = ['A', 'B', 'C', 'D'];

  @override
  void initState() {
    super.initState();
    _fetchQuestions();
  }

  Future<void> _fetchQuestions() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('quiz_questions')
        .limit(20)
        .get();

    final questions = snapshot.docs.map((doc) {
      final data = doc.data();
      return {
        'question': data['question'],
        'options': List<String>.from(data['options']),
        'answer': data['answer'], // e.g. 'A'
        'explanation': data['explanation'],
      };
    }).toList();

    questions.shuffle();

    setState(() {
      _questions = questions.take(20).toList();
    });

    _startTimer();
  }

  void _startTimer() {
    _timeLeft = 1.0;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _timeLeft -= 1 / _maxTime;
      });

      if (_timeLeft <= 0) {
        _timer?.cancel();
        _autoSubmit();
      }
    });
  }

  void _autoSubmit() {
    if (!_answered) {
      _handleAnswer(null); // No answer selected
    }
  }

  void _handleAnswer(String? selectedLabel) {
    final current = _questions[_currentIndex];
    final isCorrect = selectedLabel == current['answer'];
    final explanation = current['explanation'] ?? '';

    setState(() {
      _selectedLabel = selectedLabel;
      _answered = true;
      _timer?.cancel();

      _answerFeedback = selectedLabel == null
          ? '⏱ Time’s up!'
          : isCorrect
              ? '✅ Correct!'
              : '❌ Incorrect.';

      _explanationText = 'Explanation: $explanation';
    });

    Future.delayed(const Duration(seconds: 4), () {
      if (_currentIndex < _questions.length - 1) {
        setState(() {
          _currentIndex++;
          _selectedLabel = null;
          _answered = false;
          _answerFeedback = '';
          _explanationText = '';
        });
        _startTimer();
      } else {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('🎉 You’ve completed the quiz!')),
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_questions.isEmpty) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final question = _questions[_currentIndex];

    return Scaffold(
      appBar: AppBar(title: const Text('Real-time Quiz')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Question number
            Text(
              'Question ${_currentIndex + 1} of ${_questions.length}',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 8),

            // Timer progress bar
            LinearProgressIndicator(
              value: _timeLeft,
              minHeight: 8,
              backgroundColor: Colors.grey.shade300,
              color: Colors.blueAccent,
            ),
            const SizedBox(height: 20),

            // Question text
            Text(
              question['question'],
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 24),

            // Options with labels
            ...List.generate(question['options'].length, (index) {
              final label = _labels[index];
              final option = question['options'][index];
              final isCorrect = label == question['answer'];
              final isSelected = label == _selectedLabel;

              Color? bgColor;
              if (_answered) {
                if (isCorrect)
                  bgColor = Colors.green;
                else if (isSelected) bgColor = Colors.red;
              }

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: bgColor,
                    padding: const EdgeInsets.symmetric(
                        vertical: 14, horizontal: 16),
                    textStyle: const TextStyle(fontSize: 14),
                  ),
                  onPressed: _answered ? null : () => _handleAnswer(label),
                  child: Row(
                    children: [
                      Text('$label: ',
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      Expanded(child: Text(option)),
                      if (_answered && isCorrect)
                        const Icon(Icons.check_circle, color: Colors.white),
                      if (_answered && isSelected && !isCorrect)
                        const Icon(Icons.cancel, color: Colors.white),
                    ],
                  ),
                ),
              );
            }),

            const SizedBox(height: 16),

            // Feedback and Explanation
            if (_answered) ...[
              Text(
                _answerFeedback,
                style:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Text(
                _explanationText,
                style: const TextStyle(fontSize: 14.5, color: Colors.black87),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
