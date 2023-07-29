import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../api/booking_requests.dart';
import '../types/bookings/booking_type.dart';
import 'package:under_the_c_app/config/session_variables.dart';

class BookingProvider extends StateNotifier<List<Booking>> {
  List<Booking> _allBooking;

  BookingProvider(uid)
      : _allBooking = [],
        super([]) {
    fetchBookings(uid);
  }

  Future<void> addBooking(TicketBooking booking) async {
    Booking newBooking = Booking(
        eventId: booking.eventId,
        eventName: "1",
        eventTag: "1",
        eventVenue: "1",
        eventTime: "1");

    state = [...state, newBooking];
    _allBooking = [..._allBooking, newBooking];
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
