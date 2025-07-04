import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';

class WeeklyStatsSection extends StatefulWidget {
  final String userId;
  const WeeklyStatsSection({super.key, required this.userId});

  @override
  State<WeeklyStatsSection> createState() => _WeeklyStatsSectionState();
}

class _WeeklyStatsSectionState extends State<WeeklyStatsSection> {
  final List<String> _days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  List<double> _dailyCounts = List.filled(7, 0);
  Map<String, double> _progressData = {
    'Completed': 0,
    'In Progress': 0,
    'Started': 0,
  };
  double _totalWatchSeconds = 0;
  bool _loading = true;

  final Map<String, Color> progressColors = {
    'Completed': Colors.green,
    'In Progress': Colors.orange,
    'Started': Colors.blue,
  };

  @override
  void initState() {
    super.initState();
    _fetchStats();
  }

  Future<void> _fetchStats() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('tutorial_progress')
        .where('userId', isEqualTo: widget.userId)
        .get();

    final now = DateTime.now();
    final thisWeekStart = now.subtract(Duration(days: now.weekday - 1));

    List<double> dailyCounts = List.filled(7, 0);
    int started = 0, inProgress = 0, completed = 0;
    double totalWatchSeconds = 0;

    for (var doc in snapshot.docs) {
      final data = doc.data();
      final progress = (data['progress'] ?? 0.0) as double;
      final timestamp = (data['lastUpdated'] as Timestamp?)?.toDate();
      final duration = (data['durationWatched'] ?? 0) as int;

      if (timestamp == null) continue;

      final weekday = timestamp.weekday - 1;
      if (timestamp.isAfter(thisWeekStart)) {
        dailyCounts[weekday] += 1;
        totalWatchSeconds += duration;
      }

      if (progress >= 1.0) {
        completed += 1;
      } else if (progress >= 0.4) {
        inProgress += 1;
      } else {
        started += 1;
      }
    }

    final total = started + inProgress + completed;
    setState(() {
      _dailyCounts = dailyCounts;
      _totalWatchSeconds = totalWatchSeconds;
      _progressData = {
        'Completed': total == 0 ? 0 : completed / total,
        'In Progress': total == 0 ? 0 : inProgress / total,
        'Started': total == 0 ? 0 : started / total,
      };
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final hours = (_totalWatchSeconds / 3600).floor();
    final minutes = ((_totalWatchSeconds % 3600) / 60).round();

    return _loading
        ? const Center(child: CircularProgressIndicator())
        : Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [BoxShadow(blurRadius: 8, color: Colors.black12)],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Weekly Progress',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'OpenSans',
                  ),
                ),
                const SizedBox(height: 20),

                // 📊 Bar Chart
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: SizedBox(
                    height: 200,
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
                                if (value < 0 || value > 6) return const SizedBox.shrink();
                                return Text(_days[value.toInt()],
                                    style: const TextStyle(fontSize: 12));
                              },
                            ),
                          ),
                        ),
                        barGroups: List.generate(7, (index) {
                          final y = _dailyCounts[index];
                          return BarChartGroupData(
                            x: index,
                            barRods: [
                              BarChartRodData(
                                toY: y,
                                width: 14,
                                borderRadius: BorderRadius.circular(6),
                                gradient: const LinearGradient(
                                  colors: [Color(0xFF42A5F5), Color(0xFF1E88E5)],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                              ),
                            ],
                          );
                        }),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // 🧭 Ring Chart + Watch Time
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          CustomPaint(
                            size: const Size(120, 120),
                            painter: SegmentedRingPainter(
                              segments: _progressData.values.toList(),
                              colors: progressColors.values.toList(),
                            ),
                          ),
                          Text(
                            '${(_progressData['Completed']! * 100).toInt()}%',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 24),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ..._progressData.entries.map((entry) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Row(
                                children: [
                                  Container(
                                    width: 12,
                                    height: 12,
                                    margin: const EdgeInsets.only(right: 8),
                                    decoration: BoxDecoration(
                                      color: progressColors[entry.key],
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  Text(entry.key, style: const TextStyle(fontSize: 14)),
                                ],
                              ),
                            );
                          }),
                          const SizedBox(height: 12),
                          Text(
                            'This Week: $hours hr ${minutes.toString().padLeft(2, '0')} min watched',
                            style: const TextStyle(fontSize: 13, color: Colors.black87),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
  }
}

// 🎨 Custom Ring Painter
class SegmentedRingPainter extends CustomPainter {
  final List<double> segments;
  final List<Color> colors;

  SegmentedRingPainter({required this.segments, required this.colors});

  @override
  void paint(Canvas canvas, Size size) {
    final strokeWidth = 12.0;
    final radius = size.width / 2;
    final center = Offset(radius, radius);
    final total = segments.fold(0.0, (sum, val) => sum + val);
    double startAngle = -pi / 2;

    for (int i = 0; i < segments.length; i++) {
      final sweepAngle = (segments[i] / total) * 2 * pi;
      final paint = Paint()
        ..color = colors[i]
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius - strokeWidth / 2),
        startAngle,
        sweepAngle,
        false,
        paint,
      );
      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
