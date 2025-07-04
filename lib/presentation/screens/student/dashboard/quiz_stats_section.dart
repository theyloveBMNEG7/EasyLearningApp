import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';

class QuizStatsSection extends StatefulWidget {
  final String userId;
  const QuizStatsSection({super.key, required this.userId});

  @override
  State<QuizStatsSection> createState() => _QuizStatsSectionState();
}

class _QuizStatsSectionState extends State<QuizStatsSection> {
  final List<String> _days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  List<int> _dailyAttempts = List.filled(7, 0);
  int _totalQuizzes = 0;
  double _averageScore = 0;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchQuizStats();
  }

  Future<void> _fetchQuizStats() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('quiz_attempts')
        .where('userId', isEqualTo: widget.userId)
        .get();

    final now = DateTime.now();
    final thisWeekStart = now.subtract(Duration(days: now.weekday - 1));

    List<int> dailyAttempts = List.filled(7, 0);
    int totalScore = 0;
    int totalPossible = 0;

    for (var doc in snapshot.docs) {
      final data = doc.data();
      final timestamp = (data['timestamp'] as Timestamp?)?.toDate();
      final score = (data['score'] ?? 0) as int;
      final total = (data['total'] ?? 0) as int;

      if (timestamp == null) continue;

      if (timestamp.isAfter(thisWeekStart)) {
        final weekday = timestamp.weekday - 1;
        dailyAttempts[weekday] += 1;
      }

      totalScore += score;
      totalPossible += total;
    }

    setState(() {
      _dailyAttempts = dailyAttempts;
      _totalQuizzes = snapshot.docs.length;
      _averageScore =
          totalPossible == 0 ? 0 : (totalScore / totalPossible) * 100;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _loading
        ? const Center(child: CircularProgressIndicator())
        : Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(blurRadius: 8, color: Colors.black12)
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Quiz Performance',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'OpenSans',
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Quizzes Taken: $_totalQuizzes',
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                ),
                const SizedBox(height: 4),
                Text(
                  'Average Score: ${_averageScore.toStringAsFixed(1)}%',
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                ),
                const SizedBox(height: 20),

                // 📊 Bar Chart
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: SizedBox(
                    height: 180,
                    child: BarChart(
                      BarChartData(
                        alignment: BarChartAlignment.spaceAround,
                        gridData: FlGridData(show: false),
                        borderData: FlBorderData(show: false),
                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(),
                          topTitles: AxisTitles(),
                          rightTitles: AxisTitles(),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, _) {
                                if (value < 0 || value > 6)
                                  return const SizedBox.shrink();
                                return Text(_days[value.toInt()],
                                    style: const TextStyle(fontSize: 12));
                              },
                            ),
                          ),
                        ),
                        barGroups: List.generate(7, (index) {
                          final y = _dailyAttempts[index].toDouble();
                          return BarChartGroupData(
                            x: index,
                            barRods: [
                              BarChartRodData(
                                toY: y,
                                width: 14,
                                borderRadius: BorderRadius.circular(6),
                                color: Colors.deepOrange,
                              ),
                            ],
                          );
                        }),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}
