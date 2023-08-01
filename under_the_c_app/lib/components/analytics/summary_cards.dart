import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:under_the_c_app/components/analytics/summary_card.dart';
import 'package:under_the_c_app/config/session_variables.dart';

import '../../providers/analytics_providers.dart';

class SummaryCards extends ConsumerWidget {
  const SummaryCards({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uid = sessionVariables.uid.toString();
    final nEventsHosted = ref.watch(eventsHostedNotifier(uid));
    final nTicketsSold = ref.watch(ticketsSoldProvider(uid));
    final nSubscribers = ref.watch(subscribersProvider(uid));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Summary",
          style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w600,
              color: Color.fromARGB(255, 42, 23, 120)),
        ),
        const SizedBox(height: 10),
        Container(
          height: 100,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children:  [
              SummaryCard(
                  val: nTicketsSold,
                  type: "Tickets Sold",
                  color: Color.fromARGB(255, 96, 98, 255)),
              SizedBox(
                width: 15,
              ),
              SummaryCard(
                val: nSubscribers,
                type: "Subscribers",
                color: Color.fromARGB(255, 255, 119, 41),
              ),
              SizedBox(
                width: 15,
              ),
              SummaryCard(
                val: nEventsHosted,
                type: "Events Hosted",
                color: Color.fromARGB(255, 255, 41, 209),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
