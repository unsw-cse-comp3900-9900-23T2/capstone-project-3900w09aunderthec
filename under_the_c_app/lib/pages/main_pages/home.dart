import 'package:flutter/material.dart';
import 'package:under_the_c_app/components/common/types/events/event_type.dart';
import 'package:under_the_c_app/components/events/event_card.dart';
import 'package:under_the_c_app/pages/subpages/event_details.dart';

// @TODO: [PLHV-151] Connect with the HTTP request, details should get dynamic contents from a router
class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  // @TODO: Replace those temporary event testing data with real fetch
  final List<Event> events = [
    Event(
        title: 'S',
        imageUrl: 'images/events/money-event.jpg',
        details: SubtitleDetails('Wed', '10:15', 'M', 's')),
    Event(
        title: 'Event',
        imageUrl: 'images/events/money-event.jpg',
        details: SubtitleDetails('Wed', '10:15', 'Maroubra', 'Syd')),
    Event(
        title: 'Event this is a long long long long event',
        imageUrl: 'images/events/money-event.jpg',
        details: SubtitleDetails('Thu', '11:30', 'Bondi', 'Syd')),
    Event(
        title: 'Event 2',
        imageUrl: 'images/events/money-event.jpg',
        details: SubtitleDetails('Thu', '11:30', 'Queen Elizebeth', 'Sydney')),
  ];

  @override
  Widget build(BuildContext context) {
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
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EventDetailsPage(event: event)));
                  },
                  child: EventCard(
                      title: event.title,
                      imageUrl: event.imageUrl,
                      details: event.description),
                ));
          }, childCount: events.length))
        ],
      ),
    );
  }
}
