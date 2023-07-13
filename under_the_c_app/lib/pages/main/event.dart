import 'package:flutter/material.dart';
import 'package:under_the_c_app/components/api/get_event.dart';

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
    events = getEvents("3", true);
    print("----->events = $events");
  }

  @override
  Widget build(BuildContext context) {
    return Container(color: Colors.red, child: const Text("Hosted Events"));
  }
}
