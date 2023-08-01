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
            Container(
              height: 260,
              child: LineChartWidget(),
            ),
          ],
        ),
      ),
    );
  }
}
