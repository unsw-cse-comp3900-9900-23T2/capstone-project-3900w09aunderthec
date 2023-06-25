import 'package:flutter/material.dart';

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
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Flexible(
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
            ),
            Flexible(
                flex: 1,
                child: Row(
                  children: [
                    Flexible(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(255, 161, 163, 210),
                                  borderRadius: BorderRadius.circular(8)),
                              child: const Center(
                                child: Padding(
                                  padding: EdgeInsets.only(top: 5),
                                  child: Column(children: [
                                    Text(
                                      "APR",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                    Text(
                                      "20",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 24,
                                      ),
                                    )
                                  ]),
                                ),
                              )),
                        )),
                    Flexible(
                        flex: 3,
                        child: ListTile(
                          title: const Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: Text(
                                'Entertainment Event',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 19, fontWeight: FontWeight.bold),
                              )),
                          subtitle: const Padding(
                              padding: EdgeInsets.only(top: 1, left: 12),
                              child: Column(children: [
                                Padding(
                                  padding: EdgeInsets.only(top: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Thus 10:15 - New York, NY 2023',
                                        style: TextStyle(fontSize: 10),
                                      ),
                                      // Text('3'),
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
                  ],
                ))
          ]),
        ));
  }
}
