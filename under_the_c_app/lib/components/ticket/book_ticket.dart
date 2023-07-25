// Button in each individual event
// Pull up data for tickets

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:under_the_c_app/components/ticket/ticket_payment.dart';
import 'package:under_the_c_app/config/routes/routes.dart';
import 'package:under_the_c_app/providers/ticket_providers.dart';
import '../../api/ticket_requests.dart';
import 'display_ticket.dart';

const priceTextStyle = TextStyle(
  color: Colors.black,
  fontSize: 20.0,
  fontWeight: FontWeight.bold,
);

final selectedTicketsProvider = StateProvider<Map<int, int>>((ref) => {});
final totalPriceProvider = StateProvider<int>((ref) {
  return 0;
});

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
    var totalPrice = ref.watch(totalPriceProvider);
    final selectedTickets = ref.watch(selectedTicketsProvider);

    void cleanMap() {
      var selectedTickets = ref.watch(selectedTicketsProvider);
      selectedTickets.removeWhere((key, value) => value == 0);
    }

    void resetTicketState() {
      ref.read(selectedTicketsProvider.notifier).state = {};
      ref.read(totalPriceProvider.notifier).state = 0;
    }

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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                    16.0, kToolbarHeight + 20.0, 16.0, 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      child: Text(
                        eventTitle,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Align(
                      child: Text(eventVenue),
                    ),
                    const SizedBox(height: 20.0),
                    const Text(
                      "Choose your tickets",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10.0),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: tickets.length,
                  itemBuilder: (context, index) {
                    final ticket = tickets[index];
                    return DisplayedTicket(item: ticket);
                  },
                ),
              ),
              const SizedBox(height: 40.0),
              _buildDivider(),
              const SizedBox(height: 20.0),
              Row(
                children: [
                  const SizedBox(height: 20.0),
                  Text(
                    "Total Price",
                    style: priceTextStyle.copyWith(color: Colors.black),
                  ),
                  const Spacer(),
                  Text("\$$totalPrice",
                      style: priceTextStyle.copyWith(color: Colors.black)),
                  const SizedBox(height: 20.0),
                ],
              ),
              const SizedBox(height: 20.0),
              _buildDivider(),
              const SizedBox(height: 20.0),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: ElevatedButton(
                  onPressed: () async {
                    await showDialog(
                      context: context,
                      builder: (BuildContext context) => PaymentDialog(),
                    );
                    cleanMap();
                    if (selectedTickets.isNotEmpty) {
                      context.go(AppRoutes.ticketConfirmation(eventTitle));
                      purchaseTickets(selectedTickets);
                      resetTicketState();
                    }
                  },
                  child: const Text("Purchase"),
                ),
              ),
            ],
          ),
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
