import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:under_the_c_app/components/events/event_details/price.dart';
import 'package:under_the_c_app/types/bookings/booking_type.dart';

import '../../../config/routes/routes.dart';
import '../../../providers/booking_providers.dart';
import 'package:under_the_c_app/config/session_variables.dart';
import 'package:ticket_widget/ticket_widget.dart';

import '../../../providers/ticket_providers.dart';

class ViewBookingPage extends ConsumerWidget {
  const ViewBookingPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String uid = sessionVariables.uid.toString();
    final myBookings = ref.watch(bookingsProvider(uid));

    // Have a list of tickets with their price
    // Add the same ticket according to how many tickets have been bought
    List<IndividualDetails> individualTicketList(Booking booking) {
      List<IndividualDetails> returnedList = [];
      booking.ticketDetails.forEach(
        (key, value) {
          for (int x = 0; x < value["numberOfTickets"]; x++) {
            returnedList
                .add(IndividualDetails(name: key, price: value["price"]));
          }
        },
      );
      return returnedList;
    }

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
                    // Clicking the card takes you to relevant event
                    context.go(AppRoutes.eventDetails(booking.eventId),
                        extra: 'Details');
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Column(
                      children: [
                        // Card class to visualise booking
                        BookingCard(
                          bookingInfo: booking,
                          imageUrl: "images/events/money-event.jpg",
                          noTicket: booking.ticketNo,
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.width * 0.01,
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              // View tickets
                              ElevatedButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        backgroundColor: Colors.transparent,
                                        content: Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.7,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                1.3,
                                            // Create a list with all tickets
                                            child: ListView.builder(
                                                shrinkWrap: true,
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemCount: individualTicketList(
                                                        booking)
                                                    .length,
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  List<IndividualDetails>
                                                      details =
                                                      individualTicketList(
                                                          booking);
                                                  // Class that visualises tickets
                                                  return EventTickets(
                                                    eventName:
                                                        booking.eventName,
                                                    eventTag: booking.eventTag
                                                        .toString(),
                                                    eventVenue:
                                                        booking.eventVenue,
                                                    eventTime:
                                                        booking.eventTime,
                                                    eventCost:
                                                        booking.totalCost,
                                                    bookingNo:
                                                        booking.id.toString(),
                                                    price: details[index].price,
                                                    ticketName:
                                                        details[index].name,
                                                  );
                                                })),
                                      );
                                    },
                                  );
                                },
                                child: const Text('View Tickets'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  // Cancel booking and refund
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title:
                                            const Text('Bookings Confirmation'),
                                        content: const Text(
                                            'Are you sure you want to cancel all bookings?'),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context)
                                                  .pop(); // Close the alert
                                            },
                                            child: const Text('No'),
                                          ),
                                          TextButton(
                                            onPressed: () async {
                                              final successCancel = await ref
                                                  .read(
                                                      bookingProvider.notifier)
                                                  .removeBooking(
                                                      booking.id.toString());
                                              Navigator.of(context)
                                                  .pop(); // Close the alert
                                              // Dialogue pop up suggesting success or reasons for failure
                                              showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    successCancel
                                                        ? const AlertDialog(
                                                            title: Text(
                                                              "Cancellation of booking successfully",
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            ),
                                                          )
                                                        : const AlertDialog(
                                                            title: Text(
                                                              "Cancellation of booking failed",
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            ),
                                                            content: Text(
                                                                "Cancellation requests must be made at least 7 days prior to the event or event is non refundable."),
                                                          ),
                                              );
                                              // Refund the tickets
                                              successCancel
                                                  ? ref
                                                      .read(ticketsProvider(
                                                              booking.eventId)
                                                          .notifier)
                                                      .fetchTickets(
                                                          booking.eventId)
                                                  : null;
                                            },
                                            child: const Text('Yes'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                child: const Text('Cancel Booking'),
                              ),
                            ]),
                        SizedBox(
                          height: MediaQuery.of(context).size.width * 0.01,
                        ),
                      ],
                    ),
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
  final Booking bookingInfo;
  final String imageUrl;
  final String noTicket;

  const BookingCard({
    Key? key,
    required this.bookingInfo,
    required this.imageUrl,
    required this.noTicket,
  }) : super(key: key);

  String formatTime(int time) {
    return time.toString().padLeft(2, '0');
  }

  @override
  Widget build(BuildContext context) {
    DateTime eventDate = DateTime.parse(bookingInfo.eventTime);
    return Card(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
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
                      child: RotatedBox(
                        quarterTurns: 1,
                        child: Icon(
                          Icons.confirmation_num_outlined,
                          size: MediaQuery.of(context).size.width * 0.1,
                        ),
                      )),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.01,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.3,
                        child: Text(
                          bookingInfo.eventName,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                          // Deal with text overflow
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          softWrap: false,
                        ),
                      ),
                      Text(
                        "${formatTime(eventDate.day)}-${formatTime(eventDate.month)}-${eventDate.year}",
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.width * 0.03,
              ),
              Row(
                children: [
                  PriceTag(price: double.parse(bookingInfo.totalCost)),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.1,
                  ),
                  Text("$noTicket Tickets"),
                ],
              ),
            ],
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.4,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(15),
                bottomRight: Radius.circular(15),
              ),
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
  const EventTickets({
    Key? key,
    required this.eventName,
    required this.eventTag,
    required this.eventVenue,
    required this.eventTime,
    required this.eventCost,
    required this.bookingNo,
    required this.ticketName,
    required this.price,
  }) : super(key: key);
  final String eventName;
  final String eventTag;
  final String eventVenue;
  final String eventTime;
  final String eventCost;
  final String bookingNo;
  final String ticketName;
  final double price;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TicketWidget(
        color: const Color.fromARGB(255, 226, 235, 240),
        width: MediaQuery.of(context).size.width * 0.7,
        height: MediaQuery.of(context).size.width * 1.3,
        isCornerRounded: true,
        padding: const EdgeInsets.all(20),
        child: TicketInfo(
          eventName: eventName,
          eventTag: eventTag,
          eventVenue: eventVenue,
          eventTime: eventTime,
          eventCost: eventCost,
          bookingNo: bookingNo,
          ticketName: ticketName,
          price: price,
        ),
      ),
    );
  }
}

// Visualisation of ticket
class TicketInfo extends StatelessWidget {
  const TicketInfo({
    Key? key,
    required this.eventName,
    required this.eventTag,
    required this.eventVenue,
    required this.eventTime,
    required this.eventCost,
    required this.bookingNo,
    required this.ticketName,
    required this.price,
  }) : super(key: key);
  final String eventName;
  final String eventTag;
  final String eventVenue;
  final String eventTime;
  final String eventCost;
  final String bookingNo;
  final String ticketName;
  final double price;

  @override
  Widget build(BuildContext context) {
    String imageUrl = 'images/tickets/bc.png';
    DateTime eventDate = DateTime.parse(eventTime);
    TimeOfDay dayTime = TimeOfDay.fromDateTime(eventDate);

    String formatTime(int time) {
      return time.toString().padLeft(2, '0');
    }

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
              ticketDetailsWidget('Ticket Type', ticketName, '', ''),
              const SizedBox(height: 12),
              ticketDetailsWidget('Venue', eventVenue, '', ''),
              Padding(
                padding: const EdgeInsets.only(top: 12.0, right: 40.0),
                child: ticketDetailsWidget(
                    'Date',
                    "${eventDate.year}-${formatTime(eventDate.month)}-${formatTime(eventDate.day)}",
                    'Time',
                    "${formatTime(dayTime.hour)}:${formatTime(dayTime.minute)}"),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 12.0, right: 15),
                child: ticketDetailsWidget(
                    'Cost', '\$$price', 'Order No', bookingNo),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.only(top: 40.0, left: 30.0, right: 30.0),
          child: SizedBox(
            width: 250.0,
            height: 60.0,
            child: Image.asset(
              imageUrl,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    );
  }
}

// Details for a row in the ticket
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
