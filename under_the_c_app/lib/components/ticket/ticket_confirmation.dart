import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TicketConfirmation extends StatelessWidget {
  const TicketConfirmation({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Order Confirmation"),
      ),
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  color: Colors.blue,
                  width: double.infinity,
                  height: 300,
                ),
                Positioned(
                  top: 125,
                  left: (MediaQuery.of(context).size.width - 100) / 2,
                  child: const Icon(
                    Icons.check_circle_outline_rounded,
                    size: 80,
                    color: Colors.green,
                  ),
                ),
                Positioned(
                    top: 250,
                    height: 100,
                    width: MediaQuery.of(context).size.width,
                    child: const Text(
                      "Thank you for your purchase!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    )),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 10.0,
                  ),
                  const Text(
                    "{Event Name}",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  const Text(
                    "{Time of purchase}",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 10.0,
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Container(
                    height: 2.0,
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(5.0)),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  const Text(
                    "Order number: {order number}",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  const Text(
                    "You have booked {no tickets} ticket",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 10.0,
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  const Text(
                    "An email confirmation has been sent to {email} along with your ticket and a receipt.",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 10.0,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        context.go('/home');
                      },
                      child: const Text("View Ticket"),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
