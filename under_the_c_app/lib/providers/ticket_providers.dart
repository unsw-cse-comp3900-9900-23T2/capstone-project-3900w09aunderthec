import 'package:flutter_riverpod/flutter_riverpod.dart';
/*
class TicketProvider extends StateNotifier<List<Tickets>> {
  List<Tickets> _allTickets;

  TicketProvider(eventId)
      : _allTickets = [],
        super([]) {
    fetchTickets(eventId);
  }

  Future<void> fetchTickets(eventId) async {
    state = [await getTickets(eventId)];
  }
}

final ticketsProvider =
    StateNotifierProvider<TicketProvider, List<Tickets>>((ref, eventId) {
  return TicketProvider(eventId);
});
*/