import 'package:flutter/material.dart';
import 'package:under_the_c_app/components/functions/time/time_converter.dart';

class EventImage extends StatelessWidget {
  const EventImage({super.key});
  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: 1,
      child: ClipRRect(
        // borderRadius: BorderRadius.circular(15.0),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
        child: Image.asset(
          'images/events/money-event.jpg',
          fit: BoxFit.cover,
        ),
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
            color: const Color.fromARGB(255, 161, 163, 210),
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
  const EventDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: 3,
      child: ListTile(
        title: const Padding(
          padding: EdgeInsets.only(top: 10),
          child: Text(
            'Entertainment Event',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
          ),
        ),
        subtitle: const Padding(
          padding: EdgeInsets.only(top: 1, left: 12),
          child: EventSubtitle(),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.favorite_border),
          onPressed: () {
            print('fav button clicked');
          },
        ),
      ),
    );
  }
}

class EventSubtitle extends StatelessWidget {
  const EventSubtitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Padding(
        padding: EdgeInsets.only(top: 1, left: 12),
        child: Column(children: [
          Padding(
            padding: EdgeInsets.only(top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Thus 10:15 - New York, NY',
                  style: TextStyle(fontSize: 10),
                ),
                // Text('3'),
              ],
            ),
          )
        ]));
  }
}

class EventCard extends StatelessWidget {
  const EventCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 200,
        width: 350,
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          color: const Color.fromARGB(255, 189, 192, 245),
          child: const Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                EventImage(),
                Expanded(
                    child: Padding(
                        padding: EdgeInsets.only(left: 13),
                        child: Row(
                          children: [
                            EventDate(dateTime: "2023-11-23 04:05:34"),
                            EventDetails()
                          ],
                        )))
              ]),
        ));
  }
}
