import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../config/routes/routes.dart';
import '../../../providers/booking_providers.dart';
import 'package:under_the_c_app/config/session_variables.dart';
import 'package:ticket_widget/ticket_widget.dart';

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
                    context.go(AppRoutes.eventDetails("1"), extra: 'Details');
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(
                            onPressed: () {},
                            child: const Text('??'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              // Cancel booking and refund
                            },
                            child: const Text('Cancel Booking'),
                          ),
                        ],
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
                    padding: const EdgeInsets.all(5),
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
                  showDialog(
                      context: context,
                      builder: (context) => const AlertDialog(
                            backgroundColor: Colors.black,
                            content: EventTickets(
                              eventName: "{Name}",
                              eventTag: "{Tag}",
                              eventVenue: "{Venue}",
                              eventTime: "{Time}",
                              eventCost: "{Cost}",
                              bookingNo: "{Booking No}",
                            ),
                          ));
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

class EventTickets extends StatelessWidget {
  const EventTickets(
      {Key? key,
      required this.eventName,
      required this.eventTag,
      required this.eventVenue,
      required this.eventTime,
      required this.eventCost,
      required this.bookingNo})
      : super(key: key);
  final String eventName;
  final String eventTag;
  final String eventVenue;
  final String eventTime;
  final String eventCost;
  final String bookingNo;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TicketWidget(
        color: const Color.fromARGB(255, 226, 235, 240),
        width: 350,
        height: 500,
        isCornerRounded: true,
        padding: const EdgeInsets.all(20),
        child: TicketInfo(
            eventName: eventName,
            eventTag: eventTag,
            eventVenue: eventVenue,
            eventTime: eventTime,
            eventCost: eventCost,
            bookingNo: bookingNo),
      ),
    );
  }
}

class TicketInfo extends StatelessWidget {
  const TicketInfo({
    Key? key,
    required this.eventName,
    required this.eventTag,
    required this.eventVenue,
    required this.eventTime,
    required this.eventCost,
    required this.bookingNo,
  }) : super(key: key);
  final String eventName;
  final String eventTag;
  final String eventVenue;
  final String eventTime;
  final String eventCost;
  final String bookingNo;

  @override
  Widget build(BuildContext context) {
    String imageUrl = "images/tickets/barcode.jpg";
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 120.0,
              height: 25.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.0),
                border: Border.all(width: 1.0, color: Colors.green),
              ),
              child: Center(
                child: Text(
                  eventTag,
                  style: const TextStyle(color: Colors.green),
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Text(
            eventName,
            style: const TextStyle(
                color: Colors.black,
                fontSize: 20.0,
                fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ticketDetailsWidget('Venue', eventVenue, '', ''),
              Padding(
                padding: const EdgeInsets.only(top: 12.0, right: 52.0),
                child:
                    ticketDetailsWidget('Date', eventTime, 'Time', eventTime),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 12.0, right: 53.0),
                child: ticketDetailsWidget(
                    'Cost', eventCost, 'Order No', bookingNo),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 80.0, left: 30.0, right: 30.0),
          child: SizedBox(
            width: 250.0,
            height: 60.0,
            child: Image.asset(
              // "images/tickets/barcode.jpg",
              imageUrl,
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 30),
      ],
    );
  }
}

Widget ticketDetailsWidget(String firstTitle, String firstDesc,
    String secondTitle, String secondDesc) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Padding(
        padding: const EdgeInsets.only(left: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              firstTitle,
              style: const TextStyle(color: Colors.grey),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                firstDesc,
                style: const TextStyle(color: Colors.black),
              ),
            )
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(right: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              secondTitle,
              style: const TextStyle(color: Colors.grey),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                secondDesc,
                style: const TextStyle(color: Colors.black),
              ),
            )
          ],
        ),
      )
    ],
  );
}
