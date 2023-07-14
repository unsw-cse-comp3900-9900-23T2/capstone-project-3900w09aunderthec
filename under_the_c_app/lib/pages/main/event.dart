import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:under_the_c_app/api/api_routes.dart';
import 'package:under_the_c_app/api/events/http_event_requests.dart';
import 'package:under_the_c_app/components/events/create_event.dart';
import 'package:under_the_c_app/components/ticket/book_tickets.dart';
import 'package:under_the_c_app/config/routes.dart';
import 'package:under_the_c_app/pages/event_old.dart';

class EventPage extends StatefulWidget {
  const EventPage({Key? key}) : super(key: key);

  @override
  _EventPageState createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  late Future events;
  @override
  void initState() {
    super.initState();
    events = getEvents(true);
    print("----->events = $events");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.lightBlue,
        alignment: Alignment.center,
        child: GestureDetector(
          onTap: () => {const EventCreate()},
          // child: const Text("Event Page"),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                  alignment: Alignment.topRight,
                  child: ElevatedButton(
                      onPressed: () => {
                            context.push(AppRoutes.eventAdd),
                          },
                      child: const Text("Create Event"))),
              const Align(
                alignment: Alignment.center,
                child: Text("Event Page"),
              ),
              Align(
                  alignment: Alignment.topRight,
                  child: ElevatedButton(
                      onPressed: () => {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => BookTicketRoute()),
                            ),
                          },
                      child: const Text("Book Tickets"))),
            ],
          ),
        ));
  }
}
