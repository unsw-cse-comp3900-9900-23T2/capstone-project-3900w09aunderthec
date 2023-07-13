import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:under_the_c_app/api/events/get_event.dart';
import 'package:under_the_c_app/api/testingdata/event_testing_data.dart';
import 'package:under_the_c_app/types/events/event_type.dart';

final IncomingEventsProvider = FutureProvider<List<Event>>((ref) async {
  return getEvents("3", false);
});

final IncomingEventsProviderById =
    FutureProvider.family<Event, String>((ref, id) async {
  return fetchIncomingEventById(id);
});
