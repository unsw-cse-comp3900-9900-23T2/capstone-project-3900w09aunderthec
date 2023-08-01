import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/analytics_request.dart';

/* 
For the line graph
*/
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

/* 
For number of tickets
*/
class EventsHostedNotifier extends StateNotifier<int> {
  final String uid;
  EventsHostedNotifier(this.uid) : super(0) {
    fetch();
  }

  Future<void> fetch() async {
    state = await getNumberOfEventsHosted(uid);
  }
}

final eventsHostedNotifier =
    StateNotifierProvider.family<EventsHostedNotifier, int, String>(
  (ref, String uid) => EventsHostedNotifier(uid),
);

/* 
For number of tickets sold
*/
class TicketsSoldNotifier extends StateNotifier<int> {
  final String uid;
  TicketsSoldNotifier(this.uid) : super(0) {
    fetch();
  }

  Future<void> fetch() async {
    state = await getTicketsSold(uid);
  }
}

final ticketsSoldProvider =
    StateNotifierProvider.family<TicketsSoldNotifier, int, String>(
  (ref, String uid) => TicketsSoldNotifier(uid),
);

/* 
For number of subscribers 
*/
class NumberSubscribers extends StateNotifier<int> {
  final String uid;
  NumberSubscribers(this.uid) : super(0) {
    fetch();
  }

  Future<void> fetch() async {
    state = await getSubscribers(uid);
  }
}

final subscribersProvider =
    StateNotifierProvider.family<NumberSubscribers, int, String>(
  (ref, String uid) => NumberSubscribers(uid),
);

/* 
For get beaten by events
*/
class GetBeatenByPercentageEventsNotifier extends StateNotifier<double> {
  final String uid;
  GetBeatenByPercentageEventsNotifier(this.uid) : super(0) {
    fetch();
  }

  Future<void> fetch() async {
    state = await getPercentageBeatenBy(uid, "events");
  }
}

final percentageBeatenByEventsProvider = StateNotifierProvider.family<
    GetBeatenByPercentageEventsNotifier, double, String>(
  (ref, String uid) => GetBeatenByPercentageEventsNotifier(uid),
);

/* 
For get beaten by events
*/
class GetBeatenByPercentageSubscribersNotifier extends StateNotifier<double> {
  final String uid;
  GetBeatenByPercentageSubscribersNotifier(this.uid) : super(0) {
    fetch();
  }

  Future<void> fetch() async {
    state = await getPercentageBeatenBy(uid, "subscribers");
  }
}

final percentageBeatenBySubscribersProvider = StateNotifierProvider.family<
    GetBeatenByPercentageSubscribersNotifier, double, String>(
  (ref, String uid) => GetBeatenByPercentageSubscribersNotifier(uid),
);
