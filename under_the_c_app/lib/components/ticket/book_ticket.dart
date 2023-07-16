// Button in each individual event
// Pull up data for tickets

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:under_the_c_app/api/send_email.dart';
import 'package:under_the_c_app/config/routes/routes.dart';
import 'package:under_the_c_app/providers/ticket_providers.dart';

import '../../types/tickets/tickets_type.dart';

const priceTextStyle = TextStyle(
  color: Colors.black,
  fontSize: 20.0,
  fontWeight: FontWeight.bold,
);

class BookTicket extends ConsumerWidget {
  final String eventId;
  final String eventTitle;
  final String eventVenue;
  const BookTicket(
      {super.key,
      required this.eventId,
      required this.eventTitle,
      required this.eventVenue});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tickets = ref.watch(ticketsProvider(eventId));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Color.fromARGB(255, 33, 8, 83),
          ),
          onPressed: () =>
              context.go(AppRoutes.eventDetails(eventId), extra: "Details"),
        ),
      ),
      // extendBody: true,
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.fromLTRB(
                16.0, kToolbarHeight + 40.0, 16.0, 16.0),
            children: [
              Align(
                child: Text(
                  // "Event Title",
                  eventTitle,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Align(
                child: Text(eventVenue),
              ),
              const SizedBox(
                height: 20.0,
              ),
              const Text(
                "Choose your tickets",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 40.0,
              ),
              const SizedBox(
                height: 40.0,
              ),
              _buildDivider(),
              const SizedBox(
                height: 20.0,
              ),
              Row(
                children: [
                  const SizedBox(
                    height: 20.0,
                  ),
                  Text(
                    "Total Price",
                    style: priceTextStyle.copyWith(color: Colors.black),
                  ),
                  const Spacer(),
                  Text("\$65",
                      style: priceTextStyle.copyWith(color: Colors.black)),
                  const SizedBox(
                    height: 20.0,
                  ),
                ],
              ),
              const SizedBox(
                height: 20.0,
              ),
              _buildDivider(),
              const SizedBox(
                height: 20.0,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: ElevatedButton(
                  // style: ButtonStyle(
                  //     padding: EdgeInsets.all(16.0),
                  //     shape: RoundedRectangleBorder(
                  //         borderRadius: BorderRadius.circular(20.0))),
                  onPressed: () {
                    sendEmail();
                    context.go(AppRoutes.ticketConfirmation);
                  },
                  child: const Text("Purchase"),
                ),
              ),
            ],
          ),
          ListView.builder(itemBuilder: (context, index) {
            final ticket = tickets[index];
            return TicketTypes(item: ticket);
          }),
        ],
      ),
    );
  }
}

Container _buildDivider() {
  return Container(
    height: 2.0,
    width: double.maxFinite,
    decoration: BoxDecoration(
        color: Colors.grey, borderRadius: BorderRadius.circular(5.0)),
  );
}

class TicketTypes extends StatelessWidget {
  final Tickets item;
  int qty = 0;

  TicketTypes({Key? key, required this.item}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.name,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "\$ ${(item.price).toString()}",
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text("Sales end on July 17, 2023"),
            ],
          ),
        ),
        Flexible(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                height: 40.0,
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  IconButton(
                    iconSize: 14.0,
                    padding: const EdgeInsets.all(2.0),
                    icon: const Icon(Icons.remove),
                    onPressed: () {
                      if (qty > 0) {
                        qty--;
                      }
                    },
                  ),
                  Text(
                    "${qty}",
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    iconSize: 14.0,
                    padding: const EdgeInsets.all(2.0),
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      qty++;
                    },
                  ),
                ]),
              )
            ],
          ),
        ),
      ],
    );
  }
}
