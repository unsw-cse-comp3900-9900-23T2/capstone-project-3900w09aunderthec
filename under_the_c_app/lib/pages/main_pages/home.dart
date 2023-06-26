import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lorem_ipsum/lorem_ipsum.dart';
import 'package:under_the_c_app/components/common/types/events/event_type.dart';
import 'package:under_the_c_app/components/common/types/location/address.dart';
import 'package:under_the_c_app/components/events/event_card.dart';
import 'package:under_the_c_app/pages/subpages/event_details.dart';

final eventProvider = Provider<Event>((ref) => throw UnimplementedError());

// @TODO: [PLHV-151] Connect with the HTTP request, details should get dynamic contents from a router
class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  // @TODO: Replace those temporary event testing data with real fetch
  final List<Event> events = [
    Event(
      title: 'S',
      eventId: "1",
      imageUrl: 'images/events/money-event.jpg',
      time: "2023-02-24 03:33:45",
      address: Address(
          venue: "Elizebeth Hotel",
          suburb: "George Str",
          city: "Sydney",
          country: "Australia",
          postalCode: "2020"),
      price: 0,
      description: loremIpsum(words: 100),
    ),
    Event(
      title: 'Event',
      eventId: "2",
      imageUrl: 'images/events/money-event.jpg',
      time: "2023-01-24 03:33:45",
      address: Address(
          venue: "Seven Eleven",
          suburb: "Maroubra",
          city: "Sydney",
          country: "Australia",
          postalCode: "2025"),
      price: 1.5,
      description: loremIpsum(words: 15),
    ),
    Event(
      title: 'Event this is a long long long long event',
      eventId: "3",
      imageUrl: 'images/events/money-event.jpg',
      time: "2023-02-24 03:33:45",
      price: 4,
      address: Address(
          venue: "Seven Eleven",
          suburb: "Maroubra",
          city: "Sydney",
          country: "Australia",
          postalCode: "2025"),
      description: loremIpsum(words: 500),
    ),
    Event(
      title: 'Event 2',
      eventId: "4",
      imageUrl: 'images/events/money-event.jpg',
      time: "2023-02-24 03:33:45",
      price: 60,
      address: Address(
          venue: "Seven Eleven",
          suburb: "Maroubra",
          city: "Sydney",
          country: "Australia",
          postalCode: "2025"),
      description: loremIpsum(words: 100),
    ),
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
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final event = events[index];

              return SizedBox(
                width: 375,
                child: GestureDetector(
                    onTap: () {
                      // context(path:'/eventDetails', )
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => ProviderScope(overrides: [
                      //               eventProvider.overrideWithValue(event)
                      //             ], child: const EventDetailsPage())));
                      context.go('/eventDetails', extra: {'event': event});
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => EventDetailsPage(event: event),
                      //   ),
                      // );
                    },
                    child: Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: EventCard(
                          title: event.title,
                          imageUrl: event.imageUrl,
                          time: event.time,
                          address: event.address,
                        ))),
              );
            }, childCount: events.length),
          )
        ],
      ),
    );
  }
}
