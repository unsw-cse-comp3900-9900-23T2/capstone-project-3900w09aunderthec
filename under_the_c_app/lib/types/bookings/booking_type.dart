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
    return Booking(
      id: json['booking']['id'].toString(),
      ticketNo: (json['booking']['totalPricePayed'] +
              json['booking']['creditMoneyUsed'])
          .toString(),
      totalCost: (json['booking']['totalPricePayed']).toString(),
      // ticketNo: "1",
      // totalCost: "1",
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
