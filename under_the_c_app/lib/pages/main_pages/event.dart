import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/io_client.dart';
import 'package:under_the_c_app/components/api/event.dart';
import 'package:under_the_c_app/components/events/book_ticket.dart';
import 'package:under_the_c_app/components/events/event_card.dart';

class EventPage extends StatelessWidget {
  const EventPage({Key? key}) : super(key: key);

  // TO-DO based on the type of user fetch their events
  void getEvents() async {
    HttpClient client = HttpClient();
    client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
    var ioClient = IOClient(client);

    final registerUrl = Uri.https('10.0.2.2:7161', '/EventDisplay/ListEvents');

    try {
      final response = await ioClient.post(
        registerUrl,
        headers: {
          "Access-Control-Allow-Origin": "*",
          'Content-Type': 'application/json',
          'Accept': '*/*'
        },
        body: jsonEncode({
          // TODO: [PLHV-157] event.dart:getEvents(): change UID to possibly the email
          "uid": "1"
        }),
      );

      // server currently returns a 500 as its not implemented
      if (response.statusCode == 500) {
        print(response.body);
        throw Exception(response.body);
      }
    } catch (e) {
      print('An error occured: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // return Container(
    //     color: Colors.lightBlue,
    //     alignment: Alignment.center,
    //     child: GestureDetector(
    //       onTap: getEvents,
    //       child: Text("Event Page"),
    //     ));
    return Container(
      color: const Color.fromARGB(255, 255, 255, 255),
      alignment: Alignment.center,
      padding: const EdgeInsets.all(15),
      child: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 12, left: 4),
              child: Title(
                color: const Color.fromARGB(255, 255, 255, 255),
                child: const Text(
                  "Hosted Events",
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 42, 23, 120),
                  ),
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final event = hostedEvents[index];

              return SizedBox(
                width: 375,
                child: GestureDetector(
                  onTap: () {
                    context.go('/event_details/${event.eventId}',
                        extra: 'Details');
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: EventCard(
                      title: event.title,
                      imageUrl: event.imageUrl,
                      time: event.time,
                      address: event.address,
                    ),
                  ),
                ),
              );
            }, childCount: hostedEvents.length),
          )
        ],
      ),
    );
  }
}
