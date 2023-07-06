import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:lorem_ipsum/lorem_ipsum.dart';
import 'package:under_the_c_app/components/common/types/events/event_type.dart';
import 'package:under_the_c_app/components/common/types/location/address.dart';
import 'package:under_the_c_app/components/common/types/users/host_type.dart';

Future<List<BackendEventData>> createAllEvents(String uid) async {
  final url = Uri.https('10.0.2.2:7161', '/EventDisplay/ListEvents');
  final response = await http.post(
    url,
    headers: <String, String>{
      'Content-Type': 'application/json',
    },
    body: jsonEncode(<String, String>{
      "uid": uid,
    }),
  );

  if (response.statusCode == 200) {
    final List<dynamic> jsonList = jsonDecode(response.body);
    final List<BackendEventData> allEvents =
        jsonList.map((json) => BackendEventData.fromJson(json)).toList();
    return allEvents;
  } else {
    throw Exception('Failed to create Allevents.');
  }
}

class BackendEventData {
  final int eventId;
  final int hosterFK;
  final String title;
  final DateTime time;
  final String venue;
  final String description;
  final bool allowRefunds;
  final bool privateEvent;
  final double? rating;
  final String tags;

  BackendEventData({
    required this.eventId,
    required this.hosterFK,
    required this.title,
    required this.time,
    required this.venue,
    required this.description,
    required this.allowRefunds,
    required this.privateEvent,
    required this.rating,
    required this.tags,
  });

  @override
  String toString() {
    return 'AllEvents(eventId: $eventId, hosterFK: $hosterFK, title: $title, time: $time, venue: $venue, description: $description, allowRefunds: $allowRefunds, privateEvent: $privateEvent, rating: $rating, tags: $tags)';
  }

  factory BackendEventData.fromJson(Map<String, dynamic> json) {
    return BackendEventData(
      eventId: json['eventId'],
      hosterFK: json['hosterFK'],
      title: json['title'],
      time: DateTime.parse(json['time']),
      // time: json['time'],
      venue: json['venue'],
      description: json['description'],
      allowRefunds: json['allowRefunds'],
      privateEvent: json['privateEvent'],
      rating: json['rating'],
      tags: json['tags'],
    );
  }
}

Future<List<Event>> fetchAllIncomingEvents() async {
  List<Event> incomingEvents = [];

  try {
    final allEvents = await createAllEvents("string");

    for (var singleEvent in allEvents) {
      incomingEvents.add(Event(
        title: singleEvent.title,
        eventId: singleEvent.eventId.toString(),
        imageUrl: 'images/events/money-event.jpg',
        time: singleEvent.time.toString(),
        address: Address(
          venue: singleEvent.venue,
          suburb: "George Str",
          city: "Sydney",
          country: "Australia",
          postalCode: "2020",
        ),
        price: 0,
        description: singleEvent.description,
      ));
    }
  } catch (error) {
    // Handle error
    print('Error occurred: $error');
  }

  return incomingEvents;
}

final List<Event> incomingEvents = [
  Event(
    title: 'S',
    eventId: "1",
    imageUrl: 'images/events/money-event.jpg',
    time: "2023-02-24 03:33:45",
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

// Future<List<Event>> fetchAllIncomingEvents() async {
//   return incomingEvents;
// }

// TODO: event.dart: It's fetching fake data, need to replace with real data
Future<Event> fetchIncomingEventById(String eventId) async {
  final events = await fetchAllIncomingEvents();
  final event = events.firstWhere(
    (e) => e.eventId == eventId,
    orElse: () => throw Exception('Event not found'),
  );
  return event;
}

final List<Event> hostedEvents = [
  Event(
    title: 'Hosted Event',
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
