import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EventCreateButton extends StatelessWidget {
  const EventCreateButton({super.key});
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
      child: Container(
        padding: const EdgeInsets.all(4),
        child: ElevatedButton(
          onPressed: () {
            print("Button clicked");
            context.go('/event_add');
          },
          style: TextButton.styleFrom(
            minimumSize: const Size(70, 60),
            padding: const EdgeInsets.all(25),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
          ),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
