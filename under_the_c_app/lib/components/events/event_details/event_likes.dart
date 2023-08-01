import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EventLikes extends ConsumerStatefulWidget {
  const EventLikes({Key? key}) : super(key: key);

  @override
  _EventLikesState createState() => _EventLikesState();
}

class _EventLikesState extends ConsumerState<EventLikes> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        IconButton(
          onPressed: () => (),
          icon: Icon(Icons.heart_broken),
          iconSize: 65,
          color: Colors.red,
        ),
        Text(
          '10',
          style: TextStyle(
            color: Color.fromARGB(255, 237, 237, 237),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
