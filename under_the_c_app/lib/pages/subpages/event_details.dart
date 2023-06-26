import 'package:flutter/material.dart';
import 'package:under_the_c_app/components/common/types/events/event_type.dart';

class EventDetailsPage extends StatelessWidget {
  final Event event;
  const EventDetailsPage({Key? key, required this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: null,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,
              color: Colors
                  .white), // You might need to change color based on your needs
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(children: [
        Image.asset(
          event.imageUrl,
          fit: BoxFit.cover,
          height: 250,
          width: MediaQuery.of(context).size.width,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20, left: 30),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Column(
              children: [
                Text(
                  event.title,
                  style: const TextStyle(
                      fontSize: 30, fontWeight: FontWeight.bold),
                ),
                Text(event.time)
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
