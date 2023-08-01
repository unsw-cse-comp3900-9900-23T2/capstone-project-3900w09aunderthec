import 'package:under_the_c_app/types/events/event_type.dart';
import 'package:under_the_c_app/types/address_type.dart';

List<Event> BackendDataEventListToEvent(data) {
  List<Event> events = [];
  for (var event in data) {
    events.add(
      Event(
        hostuid: event.hosterFK.toString(),
        title: event.title,
        eventId: event.eventId.toString(),
        imageUrl: 'images/events/money-event.jpg',
        time: event.time.toString(),
        venue: event.venue,
        rating: event.rating,
        tags: [event.tags],
        // TODO: [PLHV-198] EventCreate: We need set up price in the backend, can't always have price = 0.
        price: 0,
        description: event.description,
      ),
    );
  }
  return events;
}

Event BackendDataSingleEventToEvent(data) {
  return Event(
    title: data['title'],
    hostuid: data['hosterFK'].toString(),
    eventId: data['eventId'].toString(),
    imageUrl: 'images/events/money-event.jpg',
    time: data['eventTime'].toString(),
    venue: data['venue'],
    rating: data['numberSaved'],
    isDirectRefunds: data['isDirectRefunds'],
    isPrivate: data['isPrivateEvent'],
    tags: [data['tags'].toString()],
    // TODO: [PLHV-198] EventCreate: We need set up price in the backend, can't always have price = 0.
    price: 0,
    description: data['description'],
  );
}
