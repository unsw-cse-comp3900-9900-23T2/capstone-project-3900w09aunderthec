// Button in each individual event
// Pull up data for tickets

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:under_the_c_app/components/ticket/ticket_payment.dart';
import 'package:under_the_c_app/config/routes/routes.dart';
import 'package:under_the_c_app/providers/ticket_providers.dart';
import 'package:under_the_c_app/types/bookings/booking_type.dart';
import '../../api/ticket_requests.dart';
import '../../providers/booking_providers.dart';
import 'display_ticket.dart';
import 'package:under_the_c_app/config/session_variables.dart';

const priceTextStyle = TextStyle(
  color: Colors.black,
  fontSize: 20.0,
  fontWeight: FontWeight.bold,
);

final selectedTicketsProvider = StateProvider<Map<int, int>>((ref) => {});
final totalPriceProvider = StateProvider<double>((ref) {
  return 0;
});

class BookTicket extends ConsumerStatefulWidget {
  final String eventId;
  final String eventTitle;
  final String eventVenue;

  const BookTicket(
      {super.key,
      required this.eventId,
      required this.eventTitle,
      required this.eventVenue});

  void showLoadingScreen(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible:
          false, // Prevents users from closing the dialog by tapping outside
      barrierLabel: "Loading", // Label for the barrier
      pageBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return const LoadingScreen();
      },
    );
  }

  @override
  _BookTicket createState() => _BookTicket();
}

class _BookTicket extends ConsumerState<BookTicket> {
  @override
  void initState() {
    super.initState();
    // fetch updated comments when just going to the page
    ref
        .read(ticketsProvider(widget.eventId).notifier)
        .fetchTickets(widget.eventId);
    Future.microtask(() {
      ref.read(totalPriceProvider.notifier).state = 0;
      ref.read(selectedTicketsProvider.notifier).state = {};
    });
  }

  bool isLoading = false;
  void loading() {
    setState(() {
      isLoading = !isLoading;
    });
  }

  @override
  Widget build(BuildContext context) {
    final tickets = ref.watch(ticketsProvider(widget.eventId));
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
          onPressed: () => context.go(AppRoutes.eventDetails(widget.eventId),
              extra: "Details"),
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
                        widget.eventTitle,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Align(
                      child: Text(widget.eventVenue),
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
                      // context.go(AppRoutes.ticketConfirmation(eventTitle));
                      // Show loading screen
                      widget.showLoadingScreen(context);
                      String bookingNo = await purchaseTickets(selectedTickets);
                      await ref.read(bookingProvider.notifier).addBooking(
                            TicketBooking(
                              bookingId: bookingNo,
                              eventId: widget.eventId,
                              totalPrice: totalPrice,
                              selectedTickets: selectedTickets,
                            ),
                          );
                      Navigator.of(context, rootNavigator: true).pop();
                      resetTicketState();
                      context
                          .go(AppRoutes.ticketConfirmation(widget.eventTitle));
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

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  Widget build(BuildContext context) {
    return const Center(
        child: Column(children: [
      Text("Processing payment"),
      CircularProgressIndicator()
    ]));
  }
}
