class Tickets {
  final int ticketId;
  final int eventIdRef;
  final String name;
  double price;
  int stock;

  Tickets({
    required this.ticketId,
    required this.eventIdRef,
    required this.name,
    required this.price,
    required this.stock,
  });

  factory Tickets.fromJson(Map<String, dynamic> json) {
    return Tickets(
      ticketId: json['ticketId'],
      eventIdRef: json['eventIdRef'],
      name: json['name'],
      price: json['price'].toDouble(),
      stock: json['stock'],
    );
  }
}
