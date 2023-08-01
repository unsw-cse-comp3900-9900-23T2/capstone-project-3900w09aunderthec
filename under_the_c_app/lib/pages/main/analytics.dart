import 'package:flutter/material.dart';

import '../../components/analytics/line_chart.dart';
import '../../components/analytics/summary_cards.dart';

class AnalyticsPage extends StatelessWidget {
  const AnalyticsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 30, 30, 0),
        child: Column(
          children: [
            SummaryCards(),
            SizedBox(height: 35),
            Card(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(25, 25, 15, 15),
                child: Container(
                  height: 240,
                  // width: 200,
                  child: LineChartWidget(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
