import 'package:flutter/material.dart';
import 'package:under_the_c_app/types/address_type.dart';
import 'package:under_the_c_app/types/users/host_type.dart';

class Event {
  final String? eventId;
  final String title;
  final String hostuid;
  final double price;
  final String imageUrl;
  final String description;
  final bool? isDirectRefunds;
  final double? rating;
  final List<String>? tags;
  // final Address address;
  final String venue;
  final String time;
  final bool? isPrivate;

  Event(
      {required this.title,
      required this.hostuid,
      String? imageUrl,
      String? eventId,
      required this.venue,
      String? description,
      bool? isDirectRefunds,
      this.rating,
      bool? isPrivate,
      List<String>? tags,
      required this.price,
      // required this.address,
      required this.time})
      : imageUrl = imageUrl ?? "images/events/money-event.jpg", //default image
        description = description ?? "",
        eventId = eventId ?? "",
        isDirectRefunds = isDirectRefunds ?? false,
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
  final bool isDirectRefunds;
  final bool isPrivateEvent;
  final double? rating;
  final String tags;

  BackendEventData({
    required this.eventId,
    required this.hosterFK,
    required this.title,
    required this.time,
    required this.venue,
    required this.description,
    required this.isDirectRefunds,
    required this.isPrivateEvent,
    required this.rating,
    required this.tags,
  });
  @override
  String toString() {
    return 'AllEvents(eventId: $eventId, hosterFK: $hosterFK, title: $title, time: $time, venue: $venue, description: $description, isDirectRefunds: $isDirectRefunds, isPrivateEvent: $isPrivateEvent, rating: $rating, tags: $tags)';
  }

  factory BackendEventData.fromJson(Map<String, dynamic> json) {
    return BackendEventData(
      eventId: json['eventId'],
      hosterFK: json['hosterFK'],
      title: json['title'],
      time: DateTime.parse(json['createdTime']),
      venue: json['venue'],
      description: json['description'],
      isDirectRefunds: json['isDirectRefunds'],
      isPrivateEvent: json['isPrivateEvent'],
      rating: json['rating'],
      tags: json['tags'],
    );
  }
}
