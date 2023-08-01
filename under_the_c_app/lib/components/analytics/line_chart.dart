import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:under_the_c_app/config/session_variables.dart';

import '../../providers/analytics_providers.dart';
import 'line_titles.dart';

Widget lineChartLayout(List<List<int>> data, double maxYAxisVal) {
  // background color for the area below the line
  final List<Color> gradientColors = [
    Color.fromARGB(255, 1, 205, 79),
    Color.fromARGB(255, 174, 210, 188),
  ];

  final dataInfo = [
    ...data.map((e) => FlSpot(e[0].toDouble(), e[1].toDouble()))
  ];

  return LineChart(
    duration: Duration(milliseconds: 700),
    curve: Curves.linear,
    LineChartData(
      minX: 0,
      maxX: 11,
      minY: 0,
      maxY: maxYAxisVal,
      titlesData: LineTitles.getTitleData(),
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        drawHorizontalLine: false,
        getDrawingHorizontalLine: (value) {
          return const FlLine(
              color: Color.fromARGB(255, 8, 117, 194), strokeWidth: 1);
        },
      ),
      borderData: FlBorderData(
        border: const Border(
          // only displaying the bottom and left borders
          bottom: BorderSide(color: Color.fromARGB(255, 1, 185, 102), width: 1),
          left: BorderSide(color: Color.fromARGB(255, 1, 185, 102), width: 1),
        ),
      ),
      lineBarsData: [
        LineChartBarData(
          spots: dataInfo,
          isCurved: false,
          color: const Color.fromARGB(255, 16, 202, 72),
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

class LineChartWidget extends ConsumerWidget {
  LineChartWidget({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uid = sessionVariables.uid;
    AsyncValue<List<int>> futureHostedEventsData =
        ref.watch(eventsYearlyDistributionProvider(uid.toString()));
    return futureHostedEventsData.when(
        data: (data) {
          int maxVal = 0;
          final lineGraphData = data.asMap().entries.map((e) {
            if (e.value > maxVal) {
              maxVal = e.value;
            }
            return [e.key, e.value];
          }).toList();
          return lineChartLayout(lineGraphData, maxVal.toDouble());
        },
        error: (err, stack) => Text("Error: $err"),
        loading: () => lineChartLayout([], 10));
  }
}
