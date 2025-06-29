import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';

class WeeklyStatsSection extends StatefulWidget {
  const WeeklyStatsSection({super.key});

  @override
  State<WeeklyStatsSection> createState() => _WeeklyStatsSectionState();
}

class _WeeklyStatsSectionState extends State<WeeklyStatsSection> {
  String _selectedWeek = 'This Week';

  final Map<String, List<double>> _weeklyData = {
    'This Week': [6, 5, 8, 6, 7, 4, 5],
    'Last Week': [4, 6, 5, 7, 6, 2, 3],
  };

  final List<String> _days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  final Map<String, double> progressData = {
    'Completed': 0.75,
    'In Progress': 0.45,
    'Started': 0.25,
  };

  final Map<String, Color> progressColors = {
    'Completed': Colors.green,
    'In Progress': Colors.orange,
    'Started': Colors.blue,
  };

  @override
  Widget build(BuildContext context) {
    return Container(
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
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Weekly Progress',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'OpenSans',
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedWeek,
                    onChanged: (value) =>
                        setState(() => _selectedWeek = value!),
                    items: _weeklyData.keys.map((week) {
                      return DropdownMenuItem(value: week, child: Text(week));
                    }).toList(),
                    style: const TextStyle(fontSize: 13, color: Colors.black87),
                    icon: const Icon(Icons.arrow_drop_down),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // 📈 Bar Chart Section
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
                          if (value < 0 || value > 6)
                            return const SizedBox.shrink();
                          return Text(
                            _days[value.toInt()],
                            style: const TextStyle(fontSize: 12),
                          );
                        },
                      ),
                    ),
                  ),
                  barGroups: List.generate(7, (index) {
                    final y = _weeklyData[_selectedWeek]![index];
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

          // Progress Ring Chart
          Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Ring Painter
                CustomPaint(
                  size: const Size(120, 120),
                  painter: SegmentedRingPainter(
                    segments: progressData.values.toList(),
                    colors: progressColors.values.toList(),
                  ),
                ),
                const SizedBox(width: 24),

                // Labels
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: progressData.entries.map((entry) {
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
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Custom Ring Painter
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
