import 'package:flutter/material.dart';

class EventTitle extends StatelessWidget {
  String title;
  EventTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Text(
          title,
          style: const TextStyle(
              fontSize: 30, fontWeight: FontWeight.bold, letterSpacing: 0.6),
        ),
      ),
    );
  }
}
