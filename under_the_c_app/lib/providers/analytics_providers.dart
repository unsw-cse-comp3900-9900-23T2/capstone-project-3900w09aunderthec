import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/analytics_request.dart';

class EventsDistributionNotifier extends StateNotifier<List<int>> {
  final String uid;
  EventsDistributionNotifier(this.uid) : super([]) {
    fetchDistribution();
  }

  Future<void> fetchDistribution() async {
    state = await getEventsYearlyDistributionAPI(uid);
  }

}

final eventsYearlyDistributionProvider =
    StateNotifierProvider.family<EventsDistributionNotifier, List<int>, String>(
  (ref, String uid) => EventsDistributionNotifier(uid),
);
