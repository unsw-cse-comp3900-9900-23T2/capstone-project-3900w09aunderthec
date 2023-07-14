import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:under_the_c_app/api/testingdata/event_testing_data.dart';
import 'package:under_the_c_app/components/events/event_card.dart';
import 'package:under_the_c_app/config/routes.dart';

class EventPage extends StatelessWidget {
  final bool isHost;
  const EventPage({Key? key, required this.isHost}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
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
        ),
        Positioned(
          right: 0,
          bottom: 0,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.purple,
                  borderRadius: BorderRadius.circular(20)),
              child: IconButton(
                  onPressed: () {
                    context.go(AppRoutes.eventAdd);
                  },
                  icon: const Icon(Icons.add),
                  iconSize: 50,
                  color: Color.fromARGB(255, 255, 225, 253)),
            ),
          ),
        ),
        // const EventCreate()
      ],
    );
  }
}
