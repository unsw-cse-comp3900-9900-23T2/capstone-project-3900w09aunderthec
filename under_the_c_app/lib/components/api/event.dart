import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:lorem_ipsum/lorem_ipsum.dart';
import 'package:under_the_c_app/components/common/types/events/event_type.dart';
import 'package:under_the_c_app/components/common/types/location/address.dart';
import 'package:under_the_c_app/components/common/types/users/host_type.dart';

final List<Event> incomingEvents = [
  Event(
    title: 'S',
    eventId: "1",
    imageUrl: 'images/events/money-event.jpg',
    time: "2023-02-24 03:33:45",
    isPrivate: true,
    address: Address(
        venue: "Elizebeth Hotel",
        suburb: "George Str",
        city: "Sydney",
        country: "Australia",
        postalCode: "2020"),
    price: 0,
    description: loremIpsum(words: 100),
  ),
  Event(
    title: 'Event',
    eventId: "2",
    imageUrl: 'images/events/money-event.jpg',
    time: "2023-01-24 03:33:45",
    address: Address(
        venue: "Seven Eleven",
        suburb: "Maroubra",
        city: "Sydney",
        country: "Australia",
        postalCode: "2025"),
    price: 1.5,
    description: loremIpsum(words: 15),
  ),
  Event(
    title: 'Event this is a long long long long event',
    eventId: "3",
    imageUrl: 'images/events/money-event.jpg',
    time: "2023-02-24 03:33:45",
    price: 4,
    address: Address(
        venue: "Seven Eleven",
        suburb: "Maroubra",
        city: "Sydney",
        country: "Australia",
        postalCode: "2025"),
    description: loremIpsum(words: 500),
  ),
  Event(
    title: 'Event 2',
    eventId: "4",
    isPrivate: true,
    imageUrl: 'images/events/money-event.jpg',
    time: "2023-02-24 03:33:45",
    price: 60,
    address: Address(
        venue: "Seven Eleven",
        suburb: "Maroubra",
        city: "Sydney",
        country: "Australia",
        postalCode: "2025"),
    description: loremIpsum(words: 100),
  ),
];

Future<List<Event>> fetchAllIncomingEvents() async {
  return incomingEvents;
}

// TODO: event.dart: It's fetching fake data, need to replace with real data
Future<Event> fetchIncomingEventById(String eventId) async {
  final event = incomingEvents.firstWhere((e) => e.eventId == eventId,
      orElse: () => throw Exception('Event not found'));
  return event;
}

final List<Event> hostedEvents = [
  Event(
    title: 'Hosted Event',
    eventId: "2",
    isPrivate: true,
    imageUrl: 'images/events/money-event.jpg',
    time: "2023-01-24 03:33:45",
    address: Address(
        venue: "Seven Eleven",
        suburb: "Maroubra",
        city: "Sydney",
        country: "Australia",
        postalCode: "2025"),
    price: 1.5,
    description: loremIpsum(words: 15),
  ),
  Event(
    title: 'This is a long long long long hosted event',
    eventId: "3",
    imageUrl: 'images/events/money-event.jpg',
    time: "2023-02-24 03:33:45",
    price: 4,
    address: Address(
        venue: "Seven Eleven",
        suburb: "Maroubra",
        city: "Sydney",
        country: "Australia",
        postalCode: "2025"),
    description: loremIpsum(words: 500),
  ),
  Event(
    title: 'Event 2',
    eventId: "4",
    isPrivate: true,
    imageUrl: 'images/events/money-event.jpg',
    time: "2023-02-24 03:33:45",
    price: 60,
    address: Address(
        venue: "Seven Eleven",
        suburb: "Maroubra",
        city: "Sydney",
        country: "Australia",
        postalCode: "2025"),
    description: loremIpsum(words: 100),
  ),
];

Future<List<Event>> fetchAllHostedEvents() async {
  return hostedEvents;
}

// TODO: event.dart: It's fetching fake data, need to replace with real data
Future<Event> fetchHostedEventById(String eventId) async {
  final event = incomingEvents.firstWhere((e) => e.eventId == eventId,
      orElse: () => throw Exception('Event not found'));
  return event;
}

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
