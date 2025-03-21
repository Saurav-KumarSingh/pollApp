import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class BarChartSample extends StatelessWidget {
  final Map<String, dynamic> poll;

  const BarChartSample({super.key, required this.poll});

  @override
  Widget build(BuildContext context) {
    List<dynamic> options = poll['options'];

    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
                top: 16.0, bottom: 10, left: 10, right: 10),
            child: Text(
              poll['question'], // Display the poll question
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  barTouchData: BarTouchData(enabled: false), // Disable touch
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          if (value % 10 == 0) {
                            return Text(
                              '${value.toInt()}',
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                              ),
                            );
                          }
                          return const SizedBox();
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() < options.length) {
                            return Text(options[value.toInt()]['option']);
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles:
                          SideTitles(showTitles: false), // Remove right titles
                    ),
                    topTitles: const AxisTitles(
                      sideTitles:
                          SideTitles(showTitles: false), // Remove top titles
                    ),
                  ),
                  gridData: const FlGridData(show: false), // Disable grid lines
                  borderData: FlBorderData(show: false), // Disable border
                  barGroups: List.generate(
                    options.length,
                    (index) {
                      return BarChartGroupData(
                        x: index,
                        barRods: [
                          BarChartRodData(
                            toY: options[index]['votes'].toDouble(),
                            color: Colors.blueAccent,
                            width: 20,
                            borderRadius: BorderRadius.circular(0),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 20, bottom: 20),
            padding: const EdgeInsets.all(10),
            child: SizedBox(
              height: 40,
              width: 132,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  side: const BorderSide(
                      color: Colors.purple), // Add a border color if needed
                ),
                onPressed: () {
                  Navigator.pop(context); // Navigate back
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Back',
                        style: TextStyle(
                            color: Colors
                                .purple)), // Optional: Customize text color
                    SizedBox(width: 8),
                    Icon(Icons.arrow_back,
                        color: Colors.purple), // Optional: Add an icon
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
