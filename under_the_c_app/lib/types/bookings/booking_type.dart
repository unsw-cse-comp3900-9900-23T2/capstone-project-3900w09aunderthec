class Booking {
  final int id;
  final String eventName;

  Booking({
    required this.id,
    required this.eventName,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['booking']['id'],
      eventName: json['eventName'],
    );
  }
}
