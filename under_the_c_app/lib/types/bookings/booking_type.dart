class Booking {
  final String id;
  final String ticketNo;
  final String totalCost;
  final String eventId;
  final String eventName;
  final String eventTag;
  final String eventVenue;
  final String eventTime;

  Booking({
    required this.id,
    required this.ticketNo,
    required this.totalCost,
    required this.eventId,
    required this.eventName,
    required this.eventTag,
    required this.eventVenue,
    required this.eventTime,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    // int totalTickets = 0;
    // for (var ticketType in json['tickets']) {
    //   int noTickets = ticketType['numberOfTickets'];
    //   totalTickets += noTickets;
    // }

    print(json);

    return Booking(
      id: json['booking']['id'].toString(),
      ticketNo: json['booking']['id'].toString(),
      // ticketNo: totalTickets.toString(),
      totalCost: (json['booking']['totalPricePayed']).toString(),
      eventName: json['eventName']['title'],
      eventId: json['eventName']['eventId'].toString(),
      eventTag: json['eventName']['tags'],
      eventVenue: json['eventName']['venue'],
      eventTime: json['eventName']['eventTime'],
    );
  }
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
  final double totalCost;

  BookingDetails({
    required this.bookingId,
    required this.ticketNo,
    required this.totalCost,
  });
}
