import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:under_the_c_app/api/event_requests.dart';
import 'package:under_the_c_app/api/testingdata/event_testing_data.dart';
import 'package:under_the_c_app/types/events/event_type.dart';

class EventsProvider extends StateNotifier<List<Event>> {
  // final bool isHost;
  EventsProvider() : super([]) {
    fetchEvents();
  }
  void addEvent(Event event, uid) {
    createEvent(event, uid);
    state = [...state, event];
  }

  Future<void> fetchEvents() async {
    state = await getEvents(true);
  }

  Future<void> fetchEventsById(id) async {
    state = [await getEvent(id)];
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
