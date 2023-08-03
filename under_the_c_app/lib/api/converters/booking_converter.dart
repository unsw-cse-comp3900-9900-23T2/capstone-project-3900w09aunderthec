import '../../types/bookings/booking_type.dart';
import '../booking_requests.dart';

// Helper functions for converting booking data
// Adding loyalty points
UserBooking addBackendBooking(data) {
  return UserBooking(
    bookingId: data['booking']['id'].toString(),
    loyaltyPoints: data['newLoyaltyPoints'],
    vipLevel: data['newVipLevel'],
  );
}

// Subtracting loyalty points
UserBooking removeBackendBooking(data) {
  return UserBooking(
    bookingId: data['id'].toString(),
    loyaltyPoints: data['toCustomer']['loyaltyPoints'],
    vipLevel: data['toCustomer']['vipLevel'],
  );
}

// All booking information
Future<List<Booking>> getAllBackendBooking(data) async {
  List<Booking> bookings = [];
  for (var booking in data) {
    // Get ticket information here
    BookingDetails totalTickets =
        await getBookingDetails(booking['booking']['id'].toString());

    bookings.add(
      Booking(
        id: booking['booking']['id'].toString(),
        ticketNo: totalTickets.ticketNo.toString(), // Total number of tickets
        totalCost: (booking['booking']['totalPricePayed']).toString(),
        eventName: booking['eventName']['title'],
        eventId: booking['eventName']['eventId'].toString(),
        eventTag: booking['eventName']['tags'],
        eventVenue: booking['eventName']['venue'],
        eventTime: booking['eventName']['eventTime'],
        ticketDetails: totalTickets.individualTickets,
      ),
    );
  }
  return bookings;
}

// Ticket information
BookingDetails getBackendBookingDetails(data) {
  int totalTickets = 0;
  final Map<String, Map<String, dynamic>> individualTicketDetails = {};

  for (var ticketType in data['tickets']) {
    int noTickets = ticketType['numberOfTickets'];
    individualTicketDetails[ticketType['ticket']['name']] = {
      "price": ticketType['ticket']['price'],
      "numberOfTickets": noTickets,
    };

    totalTickets += noTickets;
  }

  return BookingDetails(
    bookingId: data['booking']['id'].toString(),
    ticketNo: totalTickets,
    individualTickets: individualTicketDetails,
  );
}
