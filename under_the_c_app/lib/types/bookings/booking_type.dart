class Booking {
  final int? id;
  final String eventId;
  final String eventName;
  final String eventTag;
  final String eventVenue;
  final String eventTime;

  Booking({
    int? id,
    required this.eventId,
    required this.eventName,
    required this.eventTag,
    required this.eventVenue,
    required this.eventTime,
  }) : id = id ?? 0;

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['booking']['id'],
      eventName: json['eventName'],
      eventId: json['eventName'],
      eventTag: json['eventName'],
      eventVenue: json['eventName'],
      eventTime: json['eventName'],
    );
  }
}

class TicketBooking {
  final String eventId;
  final int totalPrice;
  final Map<int, int> selectedTickets;

  TicketBooking({
    required this.eventId,
    required this.totalPrice,
    required this.selectedTickets,
  });
}
