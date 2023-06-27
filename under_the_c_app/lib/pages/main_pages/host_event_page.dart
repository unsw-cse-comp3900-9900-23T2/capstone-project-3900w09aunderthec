import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:under_the_c_app/components/api/event.dart';
import 'package:under_the_c_app/components/events/event_card.dart';

class HostEventPage extends StatelessWidget {
  const HostEventPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 255, 255, 255),
      alignment: Alignment.center,
      padding: const EdgeInsets.all(15),
      child: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 12, left: 4),
              child: Title(
                color: const Color.fromARGB(255, 255, 255, 255),
                child: const Text(
                  "My Hosted Events",
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 42, 23, 120),
                  ),
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final event = hostedEvents[index];

              return SizedBox(
                width: 375,
                child: GestureDetector(
                  onTap: () {
                    context.go('/event_details/${event.eventId}',
                        extra: 'Details');
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: EventCard(
                      title: event.title,
                      imageUrl: event.imageUrl,
                      time: event.time,
                      address: event.address,
                    ),
                  ),
                ),
              );
            }, childCount: hostedEvents.length),
          )
        ],
      ),
    );
  }
}