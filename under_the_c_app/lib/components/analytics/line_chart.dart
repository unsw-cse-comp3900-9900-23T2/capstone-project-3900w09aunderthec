import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';

import 'line_titles.dart';

class LineChartWidget extends StatelessWidget {
  // background color for the area below the line
  final List<Color> gradientColors = [
    Color.fromARGB(255, 1, 205, 79),
    Color.fromARGB(255, 174, 210, 188),
  ];
  LineChartWidget({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        minX: 1,
        maxX: 12,
        minY: 0,
        maxY: 6,
        titlesData: LineTitles.getTitleData(),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          drawHorizontalLine: false,
          getDrawingHorizontalLine: (value) {
            return FlLine(
                color: Color.fromARGB(255, 8, 117, 194), strokeWidth: 1);
          },
        ),
        borderData: FlBorderData(
          border: const Border(
            // only displaying the bottom and left borders
            bottom:
                BorderSide(color: Color.fromARGB(255, 1, 185, 102), width: 1),
            left: BorderSide(color: Color.fromARGB(255, 1, 185, 102), width: 1),
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: [
              FlSpot(1, 3),
              FlSpot(2, 2),
              FlSpot(3, 5),
              FlSpot(6, 3),
              FlSpot(7, 2),
              FlSpot(8, 4),
              FlSpot(9, 5),
            ],
            isCurved: true,
            color: Color.fromARGB(255, 16, 202, 72),
            barWidth: 3,
            // hide dots
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: gradientColors.map((e) => e.withOpacity(0.8)).toList(),
              ),
            ),
          )
        ],
      ),
    );
  }
}
