import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EventLikes extends ConsumerStatefulWidget {
  int countLikes = 0;
  EventLikes({Key? key, required this.countLikes}) : super(key: key);

  @override
  _EventLikesState createState() => _EventLikesState();
}

class _EventLikesState extends ConsumerState<EventLikes> {
  bool isLike = false;
  int nLikes = 0;

  @override
  void initState() {
    super.initState();
    nLikes = widget.countLikes;
  }

  void toggleIsLike() {
    setState(() {
      isLike = !isLike;
      if (isLike) {
        nLikes += 1;
      } else {
        nLikes -= 1;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        IconButton(
          onPressed: () => (toggleIsLike()),
          icon: isLike ? Icon(Icons.favorite) : Icon(Icons.heart_broken),
          iconSize: 65,
          color: isLike ? Colors.green[700] : Colors.red[700],
        ),
        Text(
          nLikes.toString(),
          style: const TextStyle(
            color: Color.fromARGB(255, 237, 237, 237),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
