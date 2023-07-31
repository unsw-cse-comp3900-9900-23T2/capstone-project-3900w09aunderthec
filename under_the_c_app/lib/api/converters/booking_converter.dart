import '../../types/bookings/booking_type.dart';
import '../booking_requests.dart';

UserBooking addBackendBooking(data) {
  return UserBooking(
    bookingId: data['booking']['id'].toString(),
    // loyaltyPoints: data['booking']['toCustomer']['loyaltyPoints'],
    // vipLevel: data['booking']['toCustomer']['vipLevel'],
    loyaltyPoints: data['newLoyaltyPoints'],
    vipLevel: data['newVipLevel'],
  );
}

UserBooking removeBackendBooking(data) {
  return UserBooking(
    bookingId: data['id'].toString(),
    loyaltyPoints: data['toCustomer']['loyaltyPoints'],
    vipLevel: data['toCustomer']['vipLevel'],
  );
}

Future<List<Booking>> getAllBackendBooking(data) async {
  List<Booking> bookings = [];
  for (var booking in data) {
    BookingDetails totalTickets =
        await getBookingDetails(booking['booking']['id'].toString());
    bookings.add(
      Booking(
        id: booking['booking']['id'].toString(),
        ticketNo: totalTickets.ticketNo.toString(),
        totalCost: (booking['booking']['totalPricePayed']).toString(),
        eventName: booking['eventName']['title'],
        eventId: booking['eventName']['eventId'].toString(),
        eventTag: booking['eventName']['tags'],
        eventVenue: booking['eventName']['venue'],
        eventTime: booking['eventName']['eventTime'],
      ),
    );
  }
  return bookings;
}

BookingDetails getBackendBookingDetails(data) {
  int totalTickets = 0;
  for (var ticketType in data['tickets']) {
    int noTickets = ticketType['numberOfTickets'];
    totalTickets += noTickets;
  }

  return BookingDetails(
    bookingId: data['booking']['id'].toString(),
    ticketNo: totalTickets,
    totalCost: (data['booking']['totalPricePayed']),
  );
}
