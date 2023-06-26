import 'package:flutter/material.dart';
import 'package:under_the_c_app/components/common/types/events/event_type.dart';
import 'package:under_the_c_app/components/functions/time/time_converter.dart';

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
      body: Column(
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            event.imageUrl,
            fit: BoxFit.cover,
            height: 250,
            width: MediaQuery.of(context).size.width,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20, left: 30, bottom: 10),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.title,
                    style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.6),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${getFirstThreeLettersWeekday(event.time)} ${getMonthName(event.time)} ${getDay(event.time)} ${getYear(event.time)} at ${getTime(event.time)}',
                    style: const TextStyle(fontSize: 12, letterSpacing: 0.2),
                  )
                ],
              ),
            ),
          ),
          const Divider(
            color: Color.fromARGB(221, 147, 147, 147),
            height: 20,
            thickness: 1,
          ),
          const Padding(
            padding: EdgeInsets.only(top: 4, left: 30, bottom: 4),
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                "EVENT DETAILS",
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Color.fromARGB(221, 5, 5, 5),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
