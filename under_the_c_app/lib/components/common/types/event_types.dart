import 'package:under_the_c_app/components/events/event_card.dart';

class Event {
  final String title;
  final String imageUrl;
  final SubtitleDetails details;
  final bool isPrivate;

  Event(
      {required this.title,
      required this.imageUrl,
      required this.details,
      required this.isPrivate});
}
