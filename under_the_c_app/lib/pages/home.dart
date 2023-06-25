import 'package:flutter/material.dart';
import 'package:under_the_c_app/components/common/types/event_types.dart';
import 'package:under_the_c_app/components/events/event_card.dart';

// @TODO: [PLHV-151] Connect with the HTTP request, details should get dynamic contents from a router
class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  // @TODO: Replace those temporary event testing data with real fetch
  final List<Event> events = [
    Event(
      title: 'S',
      imageUrl: 'images/events/money-event.jpg',
      details: SubtitleDetails('Wed', '10:15', 'M', 's'),
      isPrivate: true,
    ),
    Event(
      isPrivate: true,
      title: 'Event',
      imageUrl: 'images/events/money-event.jpg',
      details: SubtitleDetails('Wed', '10:15', 'Maroubra', 'Syd'),
    ),
    Event(
      title: 'Event this is a long long long long event',
      imageUrl: 'images/events/money-event.jpg',
      details: SubtitleDetails('Thu', '11:30', 'Bondi', 'Syd'),
      isPrivate: true,
    ),
    Event(
      title: 'Event 2',
      imageUrl: 'images/events/money-event.jpg',
      details: SubtitleDetails('Thu', '11:30', 'Queen Elizebeth', 'Sydney'),
      isPrivate: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: const Color.fromARGB(1, 179, 166, 244),
      color: Color.fromARGB(255, 241, 241, 241),
      child: ListView.separated(
        itemBuilder: (context, index) {
          final event = events[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: SizedBox(
              width: 375,
              child: EventCard(
                title: event.title,
                imageUrl: event.imageUrl,
                details: event.details,
              ),
            ),
          );
        },
        separatorBuilder: (context, index) => const SizedBox(height: 10.0),
        itemCount: events.length,
      ),
    );
  }
}
