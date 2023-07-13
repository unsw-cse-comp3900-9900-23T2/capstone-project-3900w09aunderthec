import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:under_the_c_app/components/api/event_testing_data.dart';
import 'package:under_the_c_app/types/events/event_type.dart';

final IncomingEventsProvider = FutureProvider<List<Event>>((ref) async {
  return fetchAllIncomingEvents();
});

final IncomingEventsProviderById = FutureProvider.family<Event, String>((ref, id) async {
  return fetchIncomingEventById(id);
});
