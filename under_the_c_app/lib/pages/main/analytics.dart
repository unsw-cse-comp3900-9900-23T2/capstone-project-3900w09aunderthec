import 'package:flutter/material.dart';

import '../../components/analytics/events_rank.dart';
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
            const SummaryCards(),
            const SizedBox(height: 35),
            // for the line graph card
            Card(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 25, 18, 15),
                child: Container(
                  height: 240,
                  child: LineChartWidget(),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // for the ranking section
            const Row(
              children: [
                Expanded(
                  child: EventsRank(
                    percentage: 0.4,
                    color: Color.fromARGB(255, 146, 163, 255),
                    title: 'Tickets Sold',
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                    child: EventsRank(
                  percentage: 0.2,
                  color: Color.fromARGB(255, 250, 146, 54),
                  title: 'Subscribers',
                )),
              ],
            ),
            const SizedBox(height: 25)
          ],
        ),
      ),
    );
  }
}
