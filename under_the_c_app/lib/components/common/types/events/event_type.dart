import 'package:under_the_c_app/components/common/types/location/address.dart';
import 'package:under_the_c_app/components/common/types/users/host_type.dart';

class Event {
  final String title;
  final Host? host;
  final double price;
  final String imageUrl;
  final String description;
  final bool? allowRefunds;
  final double? rating;
  final Address address;
  final String time;

  Event(
      {required this.title,
      this.host,
      String? imageUrl,
      String? description,
      bool? allowRefunds,
      bool? rating,
      required this.price,
      required this.address,
      required this.time})
      : imageUrl = imageUrl ?? "images/events/money-event.jpg", //default image
        description = description ?? "",
        allowRefunds = false,
        rating = null;
}
