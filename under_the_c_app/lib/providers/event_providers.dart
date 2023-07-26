import 'dart:core';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:under_the_c_app/api/event_requests.dart';
import 'package:under_the_c_app/types/events/event_type.dart';

/* For Event Filter */
enum EventFilterType {
  none,
  arts,
  business,
  comedy,
  foodDrink,
  fashion,
  music,
  sport,
  science,
  others
}

/* For Event Sort */
enum EventSortType { none, recency, popularity, price }

/* Fetching events */
class EventsProvider extends StateNotifier<List<Event>> {
  List<Event> _allEvents;

  // final bool isHost;
  EventsProvider()
      : _allEvents = [],
        super([]) {
    fetchEvents();
  }

  Future<void> addEvent(Event event) async {
    // do http calls to create events
    Event createdEvent = await createEvent(event);

    // add the events only if it's not a private event
    if (createdEvent.isPrivate != null && !createdEvent.isPrivate!) {
      state = [...state, createdEvent];
      _allEvents = [..._allEvents, createdEvent];
    }
  }

  void removeEvent(Event event) {
    cancelEvent(event);
    state = [
      for (final e in state)
        if (e.eventId != event.eventId) e,
    ];
  }

  void changeEvent(Event event) {
    modifyEvent(event);
    state = state.map((e) => e.eventId == event.eventId ? event : e).toList();
    // final index = state.indexWhere((e) => e.eventId == event.eventId);
    // if (index != -1) {
    //   state = List.from(state)..[index] = event;
    // }
  }

  Future<void> fetchEvents() async {
    state = await getAllEvents();
    setEvents(state);
  }

  void setEvents(List<Event> events) {
    _allEvents = events;
    state = events;
  }

  void search(String query) {
    if (query.isEmpty) {
      state = _allEvents;
    }
    state = _allEvents
        .where((event) =>
            event.title.toLowerCase().startsWith(query.toLowerCase()))
        .toList();
  }

  void sort(EventSortType query) {
    switch (query) {
      case EventSortType.recency:
        // Can't change the current "events", because it will not trigger re-render of the sortedEventsProvider,
        // in order to make it re-render successfully, we need to return a new instance (in this case a new array)
        final List<Event> sortedEvents = List.from(_allEvents)
          ..sort(
            (a, b) {
              DateTime dateTime1 = DateTime.parse(a.time);
              DateTime dateTime2 = DateTime.parse(b.time);
              // sort in descending order (from most recent to the least recent)
              return dateTime1.compareTo(dateTime2);
            },
          );

        state = sortedEvents;
        break;
      case EventSortType.popularity:
        final List<Event> sortedEvents = List.from(_allEvents)
          ..sort(
            (a, b) {
              double aRating = a.rating ?? -10.0;
              double bRating = b.rating ?? -10.0;
              return aRating.compareTo(bRating);
            },
          );
        break;

      case EventSortType.price:
        final List<Event> sortedEvents = List.from(_allEvents)
          ..sort(
            (a, b) {
              return a.price.compareTo(b.price);
            },
          );
        break;

      default:
        break;
    }
  }

  void reset() {
    state = _allEvents;
  }
}

final eventsProvider = StateNotifierProvider<EventsProvider, List<Event>>(
  (ref) {
    return EventsProvider();
  },
);

final eventProvider = FutureProvider.family<Event, String>(
  (ref, id) async {
    return await getEventDetails(id);
  },
);

/* Fetch events by userid */
class EventsByUserProvider extends StateNotifier<List<Event>> {
  final String uid;
  EventsByUserProvider(this.uid) : super([]) {
    fetchEvents(uid);
  }

  Future<void> fetchEvents(String uid) async {
    state = await getUserEvents(uid);
  }

}

final eventsByUserProvider =
    StateNotifierProvider.family<EventsByUserProvider, List<Event>, String>(
  (ref, uid) {
    return EventsByUserProvider(uid);
  },
);
