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
                  // width: 125,
                  // height: 200,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Flexible(
                flex: 1,
                child: Row(
                  children: [
                    // const Text("Hello"),
                    Expanded(
                        child: ListTile(
                      title: const Padding(
                          padding: EdgeInsets.only(top: 15),
                          child: Text(
                            'Entertainment Event hehe',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 19, fontWeight: FontWeight.bold),
                          )),
                      subtitle: const Padding(
                          padding: EdgeInsets.only(top: 15),
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
