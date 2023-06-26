import 'package:under_the_c_app/components/common/types/users/host_type.dart';

class Event {
  final String title;
  final Host host;
  final String imageUrl;
  final String description;
  final bool allowRefunds;
  final double rating;
  final String venue;
  final String time;

  Event(
      {required this.title,
      required this.host,
      required this.imageUrl,
      required this.description,
      required this.allowRefunds,
      required this.rating,
      required this.venue,
      required this.time});
}
