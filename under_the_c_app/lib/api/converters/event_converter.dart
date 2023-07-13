import 'package:under_the_c_app/types/events/event_type.dart';
import 'package:under_the_c_app/types/location/address.dart';

List<Event> BackendDataToEvent(data) {
  List<Event> events = [];
  for (var event in data) {
    events.add(Event(
      title: event.title,
      eventId: event.eventId.toString(),
      imageUrl: 'images/events/money-event.jpg',
      time: event.time.toString(),
      address: Address(
        venue: event.venue,
        suburb: "",
        city: "",
        country: "",
        postalCode: "",
      ),
      // TODO: [PLHV-198] EventCreate: We need set up price in the backend, can't always have price = 0.
      price: 0,
      description: event.description,
    ));
  }
  return events;
}
