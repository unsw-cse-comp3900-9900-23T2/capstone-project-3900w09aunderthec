import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:under_the_c_app/api/event_requests.dart';
import 'package:under_the_c_app/types/events/event_type.dart';
// fetch all events
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

  Future<void> fetchEventsById(id) async {
    state = [await getEventDetails(id)];
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

// for host
class HostEventProvider extends StateNotifier<List<Event>> {
  HostEventProvider(uid) : super([]) {
    fetchHostEvents(uid);
  }
  Future<void> fetchHostEvents(uid) async {
    state = await getHostEvents(uid);
  }

  Future<void> fetchCustomerEvents(uid) async {
    state = await getCustomerEvents(uid);
  }
}

final hostEventProvider =
    StateNotifierProvider.family<HostEventProvider, List<Event>, String>(
        (ref, uid) {
  return HostEventProvider(uid);
});
