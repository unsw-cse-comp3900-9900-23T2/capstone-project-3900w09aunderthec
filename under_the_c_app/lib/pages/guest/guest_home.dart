import 'package:flutter/material.dart';
import 'package:under_the_c_app/components/api/event.dart';
import 'package:under_the_c_app/components/common/types/events/event_type.dart';
import 'package:under_the_c_app/components/events/event_card.dart';

// @TODO: [PLHV-151] Connect with the HTTP request, details should get dynamic contents from a router
class GuestPage extends StatelessWidget {
  GuestPage({Key? key}) : super(key: key);

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
                child: EventCard(
                  title: event.title,
                  imageUrl: event.imageUrl,
                  time: event.time,
                  address: event.address,
                ));
          }, childCount: events.length))
        ],
      ),
    );
  }
}
