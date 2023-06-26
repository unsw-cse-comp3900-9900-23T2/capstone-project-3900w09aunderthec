import 'package:flutter/material.dart';
import 'package:under_the_c_app/components/functions/time/time_converter.dart';

class EventImage extends StatelessWidget {
  final String imageUrl;
  const EventImage({super.key, required this.imageUrl});
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      // borderRadius: BorderRadius.circular(15.0),
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(15),
        topRight: Radius.circular(15),
      ),
      child: Image.asset(
        imageUrl,
        fit: BoxFit.cover,
      ),
    );
  }
}

class EventDate extends StatelessWidget {
  final String dateTime;
  const EventDate({Key? key, required this.dateTime}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // convert to string
    MonthData monthData = timeStampToMonth(dateTime);

    return Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
            color: const Color.fromARGB(255, 216, 216, 234),
            borderRadius: BorderRadius.circular(8)),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Column(children: [
              Text(
                monthData.monthName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              Text(
                monthData.date.toString(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              )
            ]),
          ),
        ));
  }
}

class EventDetails extends StatelessWidget {
  final String title;

  const EventDetails({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 19, fontWeight: FontWeight.bold),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 1, bottom: 10),
                child: EventSubtitle(),
              ),
            ],
          ),
        ),
        const Padding(
            padding: EdgeInsets.only(right: 10),
            child: Row(
              children: [Icon(Icons.people), Icon(Icons.people)],
            ))
      ],
    );
  }
}

class SubtitleDetails {
  final String weekday;
  final String time;
  final String suburb;
  final String city;
  SubtitleDetails(this.weekday, this.time, this.suburb, this.city);
}

class EventSubtitleProvider extends InheritedWidget {
  final SubtitleDetails subtitleDetails;

  const EventSubtitleProvider({
    Key? key,
    required this.subtitleDetails,
    required Widget child,
  }) : super(key: key, child: child);

  static EventSubtitleProvider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<EventSubtitleProvider>();
  }

  @override
  bool updateShouldNotify(covariant EventSubtitleProvider oldWidget) {
    return subtitleDetails.weekday != oldWidget.subtitleDetails.weekday ||
        subtitleDetails.time != oldWidget.subtitleDetails.time ||
        subtitleDetails.suburb != oldWidget.subtitleDetails.suburb ||
        subtitleDetails.city != oldWidget.subtitleDetails.city;
  }
}

class EventSubtitle extends StatelessWidget {
  const EventSubtitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    EventSubtitleProvider? subtitleDetails = EventSubtitleProvider.of(context);
    SubtitleDetails details = subtitleDetails!.subtitleDetails;

    return Padding(
        padding: const EdgeInsets.only(top: 1, left: 12),
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${details.weekday} ${details.time} - ${details.suburb}, ${details.city}',
                  style: const TextStyle(fontSize: 10, letterSpacing: 0.4),
                ),
              ],
            ),
          )
        ]));
  }
}

class EventCard extends StatelessWidget {
  final String title;
  final String imageUrl;
  final SubtitleDetails details;

  const EventCard(
      {Key? key,
      required this.title,
      required this.imageUrl,
      required this.details})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 190,
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          color: Color.fromARGB(255, 241, 241, 241),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Flexible(
              child: EventImage(imageUrl: imageUrl),
            ),
            Flexible(
                child: Padding(
                    padding: const EdgeInsets.only(left: 13),
                    child: Row(
                      children: [
                        const EventDate(dateTime: "2023-11-21 04:05:34"),
                        Flexible(
                          child: EventSubtitleProvider(
                              subtitleDetails: details,
                              child: EventDetails(title: title)),
                        )
                      ],
                    )))
          ]),
        ));
  }
}
