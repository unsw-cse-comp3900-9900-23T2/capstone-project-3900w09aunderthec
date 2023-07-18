import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../api/ticket_requests.dart';
import '../types/tickets/tickets_type.dart';

class TicketProvider extends StateNotifier<List<Tickets>> {
  TicketProvider(eventId) : super([]) {
    fetchTickets(eventId);
  }

  Future<void> fetchTickets(eventId) async {
    state = await getTickets(eventId);
  }
}

final ticketsProvider =
    StateNotifierProvider.family<TicketProvider, List<Tickets>, String>(
        (ref, eventId) {
  return TicketProvider(eventId);
});
