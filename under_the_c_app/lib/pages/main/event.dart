import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:http/io_client.dart';
import 'package:under_the_c_app/components/ticket/book_tickets.dart';
import 'package:under_the_c_app/components/events/create_event.dart';
import '../../components/events/create_event.dart';
import '../../components/ticket/book_tickets.dart';
import 'package:http/io_client.dart';


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
    return Container(
        color: Colors.lightBlue,
        alignment: Alignment.center,
        child: GestureDetector(
          onTap: getEvents,
          // child: const Text("Event Page"),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                  alignment: Alignment.topRight,
                  child: ElevatedButton(
                      onPressed: () => {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const CreateEventRoute()),
                            ),
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
