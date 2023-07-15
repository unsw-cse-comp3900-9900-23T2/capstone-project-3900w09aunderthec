import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:under_the_c_app/api/event_requests.dart';
import 'package:under_the_c_app/api/testingdata/event_testing_data.dart';
import 'package:under_the_c_app/types/events/event_type.dart';

class EventsProvider extends StateNotifier<List<Event>> {
  List<Event> _allEvents;

  // final bool isHost;
  EventsProvider()
      : _allEvents = [],
        super([]) {
    fetchEvents();
  }

  void setEvents(List<Event> events) {
    _allEvents = events;
    state = events;
  }

  void addEvent(Event event, uid) {
    createEvent(event, uid);
    state = [...state, event];
  }

  Future<void> fetchEvents() async {
    state = await getEvents(true);
    setEvents(state);
  }

  Future<void> fetchEventsById(id) async {
    state = [await getEvent(id)];
  }

  void search(String query) {
    if (query.isEmpty) {
      state = _allEvents;
    }
    state = _allEvents
        .where(
            (event) => event.title.toLowerCase().startsWith(query.toLowerCase()))
        .toList();
  }
}

final eventsProvider =
    StateNotifierProvider<EventsProvider, List<Event>>((ref) {
  return EventsProvider();
});

final eventProvider = FutureProvider.family<Event, String>((ref, id) async {
  return await getEvent(id);
});

// Example of having arguments
// final eventsProvider =
//     StateNotifierProvider.family<EventsProvider, List<Event>, String>(
//         (ref, uid) {
//   return EventsProvider(uid);
// });

final IncomingEventsProviderById = FutureProvider.family<Event, String>(
  (ref, id) async {
    return fetchIncomingEventById(id);
  },
);
