import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EventButton extends StatelessWidget {
  const EventButton({super.key});
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: const EdgeInsets.all(20),
        child: ElevatedButton(
          onPressed: () {
            print("Button clicked");
            context.go('/event_booking/1');
          },
          style: TextButton.styleFrom(
            minimumSize: const Size(150, 0),
            padding: const EdgeInsets.all(20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
          ),
          child: const Text("Buy Ticket"),
        ),
      ),
    );
  }
}
