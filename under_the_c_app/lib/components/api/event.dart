import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lorem_ipsum/lorem_ipsum.dart';
import 'package:under_the_c_app/components/common/types/events/event_type.dart';
import 'package:under_the_c_app/components/common/types/location/address.dart';
import 'package:under_the_c_app/components/common/types/users/host_type.dart';

final List<Event> events = [
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

Future<List<Event>> fetchAllEvents() async {
  return events;
}

// TODO: event.dart: It's fetching fake data, need to replace with real data
Future<Event> fetchEventById(String eventId) async {
  final event = events.firstWhere((e) => e.eventId == eventId,
      orElse: () => throw Exception('Event not found'));
  return event;
}
