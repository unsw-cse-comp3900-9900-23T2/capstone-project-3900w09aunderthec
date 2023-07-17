import 'dart:core';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:under_the_c_app/api/event_requests.dart';
import 'package:under_the_c_app/types/events/event_type.dart';

/* Sorting or filtering events */
enum EventSortType { none, recency, popularity, price }

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

final eventFilterTypeProvider = StateProvider((ref) => EventFilterType.none);
final eventSortTypeProvider =
    StateProvider((ref) => EventSortType.none /*Here it set to default*/);

final sortedEventsProvider = Provider<List<Event>>((ref) {
  final List<Event> events = ref.watch(eventsProvider);
  final sortType = ref.watch(eventSortTypeProvider);
  switch (sortType) {
    case EventSortType.recency:
      return events
        ..sort(
          (a, b) {
            DateTime dateTime1 = DateTime.parse(a.time);
            DateTime dateTime2 = DateTime.parse(b.time);
            // sort in descending order (from most recent to the leaste recent)
            return dateTime2.compareTo(dateTime1);
          },
        );
    case EventSortType.popularity:
      return events;

    case EventSortType.price:
      return events;

    case EventSortType.none:
      return events;
  }
});

/* Fetching all events */
class EventsProvider extends StateNotifier<List<Event>> {
  List<Event> _allEvents;

  // final bool isHost;
  EventsProvider()
      : _allEvents = [],
        super([]) {
    fetchEvents();
  }

  void addEvent(Event event) {
    // do http calls to create events
    createEvent(event);

    // update the state for the EventsProvider
    state = [...state, event];
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
