import 'package:under_the_c_app/types/events/event_type.dart';
import 'package:under_the_c_app/types/address_type.dart';

List<Event> BackendDataEventListToEvent(data) {
  List<Event> events = [];
  for (var event in data) {
    events.add(
      Event(
        hostuid: event.hosterId.toString(),
        title: event.title,
        eventId: event.eventId.toString(),
        imageUrl: 'images/events/money-event.jpg',
        time: event.time.toString(),
        venue: event.venue,
        rating: event.rating,
        tags: [event.tags],
        price: event.price,
        description: event.description,
      ),
    );
  }
  return events;
}

Event BackendDataSingleEventToEvent(data) {
  return Event(
    title: data['title'],
    hostuid: data['hosterId'].toString(),
    eventId: data['eventId'].toString(),
    imageUrl: 'images/events/money-event.jpg',
    time: data['eventTime'].toString(),
    venue: data['venue'],
    rating: data['numberSaved'],
    isDirectRefunds: data['isDirectRefunds'],
    isPrivate: data['isPrivateEvent'],
    tags: [data['tags'].toString()],
    price: 0,
    description: data['description'],
  );
}

Event BackendDataSingleEventToEventIncludePrice(data) {
  return Event(
    title: data['title'],
    hostuid: data['hosterId'].toString(),
    eventId: data['eventId'].toString(),
    imageUrl: 'images/events/money-event.jpg',
    time: data['eventTime'].toString(),
    venue: data['venue'],
    isDirectRefunds: data['isDirectRefunds'],
    isPrivate: data['isPrivateEvent'],
    tags: [data['tags'].toString()],
    rating: data['numberSaved'],
    price: data['cheapestPrice'],
    description: data['description'],
  );
}
