import 'package:flutter/material.dart';

class EventCard extends StatelessWidget {
  const EventCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 135,
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          color: const Color.fromARGB(255, 189, 192, 245),
          child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Flexible(
              flex: 1,
              child: ClipRRect(
                // borderRadius: BorderRadius.circular(15.0),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15),
                  bottomLeft: Radius.circular(15),
                ),
                child: Image.asset(
                  'images/events/money-event.jpg',
                  // width: 125,
                  // height: 130,
                  fit: BoxFit.cover,
                ),
              ),
              // child: AspectRatio(
              //   aspectRatio: 1 / 1,
              //   child: ClipRRect(
              //     // borderRadius: BorderRadius.circular(15.0),
              //     borderRadius: const BorderRadius.only(
              //       topLeft: Radius.circular(15),
              //       bottomLeft: Radius.circular(15),
              //     ),
              //     child: Image.asset(
              //       'images/events/money-event.jpg',
              //       // width: 125,
              //       // height: 130,
              //       fit: BoxFit.cover,
              //     ),
              //   ),
              // ),
            ),
            Flexible(
                flex: 2,
                child: ListTile(
                  title: const Text(
                    'Entertainment Event hehe',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  subtitle: const Padding(
                      padding: EdgeInsets.only(top: 15),
                      child: Column(children: [
                        Text('Alexdander venue, NSW'),
                        Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('1 June 2023'),
                              Text('3 dollars'),
                            ],
                          ),
                        )
                      ])),
                  trailing: IconButton(
                      icon: const Icon(Icons.favorite_border),
                      onPressed: () {
                        // ignore: avoid_print
                        print('fav button clicked');
                      }),
                ))
          ]),
        ));
  }
}
