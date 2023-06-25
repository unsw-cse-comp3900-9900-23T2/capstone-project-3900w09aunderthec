import 'package:flutter/material.dart';
import 'package:under_the_c_app/components/events/event_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.lightGreen,
        alignment: Alignment.center,
        // child: const Text("Home Page"));
        child: const EventCard(),
    );
  }
}

