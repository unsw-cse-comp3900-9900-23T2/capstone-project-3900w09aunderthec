import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:under_the_c_app/config/session_variables.dart';

import '../../components/analytics/events_rank.dart';
import '../../components/analytics/line_chart.dart';
import '../../components/analytics/summary_cards.dart';
import '../../providers/analytics_providers.dart';

class AnalyticsPage extends ConsumerWidget {
  const AnalyticsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uid = sessionVariables.uid.toString();
    final percentageBeatenByEvents =
        ref.watch(percentageBeatenByEventsProvider(uid));
    final percentageBeatenBySubscribers =
        ref.watch(percentageBeatenBySubscribersProvider(uid));
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
            Row(
              children: [
                Expanded(
                  child: EventsRank(
                    percentage: percentageBeatenByEvents,
                    color: Color.fromARGB(255, 146, 163, 255),
                    title: 'Events hosted',
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                    child: EventsRank(
                  percentage: percentageBeatenBySubscribers,
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
