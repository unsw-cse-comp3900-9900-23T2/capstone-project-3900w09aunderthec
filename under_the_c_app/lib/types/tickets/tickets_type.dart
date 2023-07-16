import 'dart:ffi';

class Tickets {
  final int ticketId;
  final int eventIdRef;
  final String name;
  final double price;

  Tickets({
    required this.ticketId,
    required this.eventIdRef,
    required this.name,
    required this.price,
  });

  factory Tickets.fromJson(Map<String, dynamic> json) {
    return Tickets(
      ticketId: json['ticketId'],
      eventIdRef: json['eventIdRef'],
      name: json['name'],
      price: json['price'].toDouble(),
    );
  }
}
