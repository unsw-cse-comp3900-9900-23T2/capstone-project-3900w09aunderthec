import 'package:flutter/material.dart';
import 'package:under_the_c_app/types/address.dart';
import 'package:under_the_c_app/types/users/host_type.dart';

class Event {
  final String? eventId;
  final String title;
  final Host? host;
  final double price;
  final String imageUrl;
  final String description;
  final bool? allowRefunds;
  final double? rating;
  final List<String>? tags;
  final Address address;
  final String time;
  final bool? isPrivate;

  Event(
      {required this.title,
      this.host,
      String? imageUrl,
      String? eventId,
      String? description,
      bool? allowRefunds,
      this.rating,
      bool? isPrivate,
      List<String>? tags,
      required this.price,
      required this.address,
      required this.time})
      : imageUrl = imageUrl ?? "images/events/money-event.jpg", //default image
        description = description ?? "",
        eventId = eventId ?? "",
        allowRefunds = allowRefunds ?? false,
        isPrivate = isPrivate ?? false,
        tags = [];
}

const List<Widget> eventTypes = <Widget>[
  Text('Private'),
  Text('Public'),
];

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
      venue: json['venue'],
      description: json['description'],
      allowRefunds: json['allowRefunds'],
      privateEvent: json['privateEvent'],
      rating: json['rating'],
      tags: json['tags'],
    );
  }
}
