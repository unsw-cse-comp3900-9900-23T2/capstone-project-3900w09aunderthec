import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:under_the_c_app/api/event_requests.dart';
import 'package:under_the_c_app/types/events/event_type.dart';

class EventsProvider extends StateNotifier<List<Event>> {
  // final bool isHost;
  EventsProvider() : super([]) {
    fetchEvents();
  }

  void addEvent(Event event) {
    createEvent(event);
    state = [...state, event];
  }

  Future<void> fetchEvents() async {
    state = await getAllEvents();
  }

  Future<void> fetchEventsById(id) async {
    state = [await getEventDetails(id)];
  }

  Future<void> fetchCustomerEvents(uid) async {
    state = await getCustomerEvents(uid);
  }

  Future<void> fetchHostEvents(uid) async {
    state = await getHostEvents(uid);
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


// final IncomingEventsProviderById = FutureProvider.family<Event, String>(
//   (ref, id) async {
//     return fetchIncomingEventById(id);
//   },
// );
