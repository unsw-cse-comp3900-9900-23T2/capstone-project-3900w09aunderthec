import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../config/routes/routes.dart';
import '../../../providers/booking_providers.dart';
import 'package:under_the_c_app/config/session_variables.dart';

class ViewBookingPage extends ConsumerWidget {
  const ViewBookingPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myBookings =
        ref.watch(bookingsProvider(sessionVariables.uid.toString()));

    return Container(
      color: const Color.fromARGB(255, 255, 255, 255),
      alignment: Alignment.center,
      padding: const EdgeInsets.all(15),
      child: CustomScrollView(
        slivers: <Widget>[
          const SliverPadding(padding: EdgeInsets.only(bottom: 30)),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 12, left: 4),
              child: Title(
                color: const Color.fromARGB(255, 255, 255, 255),
                child: const Text(
                  "All Bookings",
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 42, 23, 120),
                  ),
                ),
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(
              height: 13, // Modify this to adjust the size of the space
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final booking = myBookings[index];
              return SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: GestureDetector(
                  onTap: () {
                    // Go to event
                    // Need event id
                    // context.go(AppRoutes.eventDetails(event.eventId!), extra: 'Details');
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Column(children: [
                      Text(
                        "Booking Id: ${booking.id}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      BookingCard(
                        eventName: booking.eventName,
                        imageUrl: "images/events/money-event.jpg",
                        date: "27/08/23",
                        noTicket: "3",
                      ),
                    ]),
                  ),
                ),
              );
            }, childCount: myBookings.length),
          )
        ],
      ),
    );
  }
}

class BookingCard extends StatelessWidget {
  final String eventName;
  final String imageUrl;
  final String date;
  final String noTicket;

  const BookingCard({
    Key? key,
    required this.eventName,
    required this.imageUrl,
    required this.date,
    required this.noTicket,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Card(
        color: const Color.fromARGB(255, 241, 241, 241),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: EdgeInsets.all(5),
                    child: Icon(
                      Icons.confirmation_num_outlined,
                      size: MediaQuery.of(context).size.width * 0.1,
                    ),
                  ),
                  Column(
                    children: [
                      Text(
                        "Event Name: $eventName",
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text("Event Time: $date"),
                    ],
                  ),
                ],
              ),
              Text("$noTicket Tickets"),
              ElevatedButton(
                onPressed: () {
                  // Go to my tickets
                  // context.go(AppRoutes.home);
                },
                child: const Text('View Tickets'),
              ),
            ],
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.4,
            child: ClipRRect(
              child: Image.asset(
                imageUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ]));
  }
}
