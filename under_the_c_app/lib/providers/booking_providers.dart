import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../api/booking_requests.dart';
import '../api/event_requests.dart';
import '../types/bookings/booking_type.dart';
import 'package:under_the_c_app/config/session_variables.dart';

import '../types/events/event_type.dart';

class BookingProvider extends StateNotifier<List<Booking>> {
  List<Booking> _allBooking;

  BookingProvider(uid)
      : _allBooking = [],
        super([]) {
    fetchBookings(uid);
  }

  Future<void> addBooking(TicketBooking booking) async {
    Event details = await getEventDetails(booking.eventId);
    int noTicket = 0;

    booking.selectedTickets.forEach((key, value) {
      noTicket += value;
    });

    Booking newBooking = Booking(
        id: booking.bookingId,
        eventId: booking.eventId,
        ticketNo: noTicket.toString(),
        totalCost: booking.totalPrice.toString(),
        eventName: details.title,
        eventTag: details.tags![0],
        eventVenue: details.venue,
        eventTime: details.time);

    state = [...state, newBooking];
    _allBooking = [..._allBooking, newBooking];
  }

  Future<void> removeBooking(String bookingId) async {
    UserBooking refundable = await cancelBooking(int.parse(bookingId));

    if (refundable != Null) {
      // Only lose points if event host refuses refund
      sessionVariables.loyaltyPoints = refundable.loyaltyPoints;
      sessionVariables.vipLevel = refundable.vipLevel;
      state = [
        for (final b in state)
          if (b.id.toString() != bookingId) b,
      ];
    }
  }

  Future<void> fetchBookings(uid) async {
    state = await getBookings(uid);
    setBookings(state);
  }

  void setBookings(List<Booking> bookings) {
    _allBooking = bookings;
    state = bookings;
  }
}

final bookingProvider =
    StateNotifierProvider<BookingProvider, List<Booking>>((ref) {
  final uid = sessionVariables.uid.toString();
  return BookingProvider(uid);
});

final bookingsProvider =
    StateNotifierProvider.family<BookingProvider, List<Booking>, String>(
        (ref, uid) {
  final bookingProviderStateNotifier = ref.read(bookingProvider.notifier);
  return bookingProviderStateNotifier;
  // return BookingProvider(uid);
});
