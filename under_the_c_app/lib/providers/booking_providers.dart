import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../api/booking_requests.dart';
import '../types/bookings/booking_type.dart';

class BookingProvider extends StateNotifier<List<Booking>> {
  BookingProvider(uid) : super([]) {
    fetchBookings(uid);
  }

  Future<void> fetchBookings(uid) async {
    state = await getBookings(uid);
  }
}

final bookingsProvider =
    StateNotifierProvider.family<BookingProvider, List<Booking>, String>(
        (ref, uid) {
  return BookingProvider(uid);
});
