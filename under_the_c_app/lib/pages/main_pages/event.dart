import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/io_client.dart';
import 'package:under_the_c_app/components/events/book_ticket.dart';

class EventPage extends StatelessWidget {
  const EventPage({Key? key}) : super(key: key);

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
          child: Text("Event Page"),
        ));
  }
}
