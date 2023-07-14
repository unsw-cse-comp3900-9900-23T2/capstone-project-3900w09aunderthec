import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:under_the_c_app/api/events/http_event_requests.dart';
import 'package:under_the_c_app/api/testingdata/event_testing_data.dart';
import 'package:under_the_c_app/types/events/event_type.dart';

class EventsProvider extends StateNotifier<List<Event>> {
  final String uid;
  // final bool isHost;
  EventsProvider(this.uid) : super([]) {
    fetchEvents();
  }
  void addEvent(Event event, String uid) {
    createEvent(event, uid);
    state = [...state, event];
    print("------->addEvent: printing state");
    for (var person in state) {
      print(person.toString());
    }
  }

  Future<void> fetchEvents() async {
    state = await getEvents(uid, true);
    print("------->fetchEvents: printing state");
    for (var person in state) {
      print(person.toString());
    }
  }
}

final eventsProvider =
    StateNotifierProvider.family<EventsProvider, List<Event>, String>(
        (ref, uid) {
  return EventsProvider(uid);
});

// Old code
// final IncomingEventsProvider = FutureProvider<List<Event>>((ref) async {
//   return getEvents("3", false);
// });

final IncomingEventsProviderById = FutureProvider.family<Event, String>(
  (ref, id) async {
    return fetchIncomingEventById(id);
  },
);
