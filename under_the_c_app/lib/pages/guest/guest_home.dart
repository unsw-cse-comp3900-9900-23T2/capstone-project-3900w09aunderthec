import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:under_the_c_app/api/testingdata/event_testing_data.dart';
import 'package:under_the_c_app/providers/event_providers.dart';
import 'package:under_the_c_app/types/events/event_type.dart';
import 'package:under_the_c_app/components/events/event_card.dart';

class GuestPage extends ConsumerWidget {
  const GuestPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final events = ref.watch(eventsProvider);

    // making a custom scrolling view
    return Container(
      color: const Color.fromARGB(255, 255, 255, 255),
      alignment: Alignment.center,
      padding: const EdgeInsets.all(15),
      child: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10, left: 4),
              child: Title(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  child: const Text(
                    "Upcoming Events",
                    style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 42, 23, 120)),
                  )),
            ),
          ),
          SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
            final event = events[index];
            return SizedBox(
                width: 375,
                child: EventCard(
                  title: event.title,
                  imageUrl: event.imageUrl,
                  time: event.time,
                  venue: event.venue,
                ));
          }, childCount: events.length))
        ],
      ),
    );
  }
}
