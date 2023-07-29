import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:under_the_c_app/api/testingdata/event_testing_data.dart';
import 'package:under_the_c_app/components/events/event_card.dart';
import 'package:under_the_c_app/config/routes/routes.dart';
import 'package:under_the_c_app/config/session_variables.dart';
import 'package:under_the_c_app/providers/event_providers.dart';

class EventPage extends ConsumerWidget {
  final bool isHost;
  const EventPage({Key? key, required this.isHost}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isHost = sessionVariables.sessionIsHost;
    final String uid = sessionVariables.uid.toString();
    final events = ref.watch(eventsByUserProvider(uid));
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
                    child: Text(
                      isHost ? "My Hosted Events" : "My Incoming Events",
                      style: const TextStyle(
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
                  final event = events[index];

                  return SizedBox(
                    width: 375,
                    child: GestureDetector(
                      onTap: () {
                        context.go(AppRoutes.eventDetails(event.eventId!));
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: EventCard(
                          title: event.title,
                          imageUrl: event.imageUrl,
                          time: event.time,
                          venue: event.venue,
                        ),
                      ),
                    ),
                  );
                }, childCount: events.length),
              )
            ],
          ),
        ),
        isHost
            ? Positioned(
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
                        iconSize: 45,
                        color: const Color.fromARGB(255, 255, 225, 253)),
                  ),
                ),
              )
            : Positioned(
                right: 0,
                bottom: 0,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  // child: Container(
                  //   decoration: BoxDecoration(
                  //       color: Colors.purple,
                  //       borderRadius: BorderRadius.circular(20)),
                  //   child: IconButton(
                  //       onPressed: () {
                  //         showDialog(
                  //           context: context,
                  //           builder: (BuildContext context) {
                  //             return AlertDialog(
                  //               title: const Text('Bookings Confirmation'),
                  //               content: const Text(
                  //                   'Are you sure you want to cancel all bookings?'),
                  //               actions: [
                  //                 TextButton(
                  //                   onPressed: () {
                  //                     Navigator.of(context)
                  //                         .pop(); // Close the alert
                  //                   },
                  //                   child: const Text('No'),
                  //                 ),
                  //                 TextButton(
                  //                   onPressed: () {
                  //                     Navigator.of(context)
                  //                         .pop(); // Close the alert
                  //                     // TO-DO call cancelAll api request
                  //                   },
                  //                   child: const Text('Yes'),
                  //                 ),
                  //               ],
                  //             );
                  //           },
                  //         );
                  //       },
                  //       icon: const Icon(Icons.remove),
                  //       iconSize: 45,
                  //       color: const Color.fromARGB(255, 255, 225, 253)),
                  // ),
                ),
              ),
      ],
    );
  }
}
