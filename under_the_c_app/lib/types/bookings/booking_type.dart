class Booking {
  final String id;
  final String ticketNo;
  final String totalCost;
  final String eventId;
  final String eventName;
  final String eventTag;
  final String eventVenue;
  final String eventTime;
  final Map<String, Map<String, dynamic>> ticketDetails;

  Booking({
    required this.id,
    required this.ticketNo,
    required this.totalCost,
    required this.eventId,
    required this.eventName,
    required this.eventTag,
    required this.eventVenue,
    required this.eventTime,
    required this.ticketDetails,
  });
}

class TicketBooking {
  final String bookingId;
  final String eventId;
  final double totalPrice;
  final Map<int, int> selectedTickets;

  TicketBooking({
    required this.bookingId,
    required this.eventId,
    required this.totalPrice,
    required this.selectedTickets,
  });
}

class UserBooking {
  final String bookingId;
  final int loyaltyPoints;
  final int vipLevel;

  UserBooking({
    required this.bookingId,
    required this.loyaltyPoints,
    required this.vipLevel,
  });
}

class BookingDetails {
  final String bookingId;
  final int ticketNo;
  // final double totalCost;
  final Map<String, Map<String, dynamic>> individualTickets;

  BookingDetails({
    required this.bookingId,
    required this.ticketNo,
    // required this.totalCost,
    required this.individualTickets,
  });
}

class IndividualDetails {
  final String name;
  // final int numberOfTicket;
  final double price;

  IndividualDetails({
    required this.name,
    // required this.numberOfTicket,
    required this.price,
  });
}
