import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:under_the_c_app/config/session_variables.dart';

import '../../../api/event_requests.dart';
import '../../../providers/event_providers.dart';

class EventLikes extends ConsumerStatefulWidget {
  int countLikes = 0;
  String eventId;
  EventLikes({Key? key, required this.countLikes, required this.eventId})
      : super(key: key);

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

  void toggleIsLike() async {
    setState(() {
      isLike = !isLike;
      if (isLike) {
        nLikes += 1;
      } else {
        nLikes -= 1;
      }
    });

    await toggleLikeEventAPI(sessionVariables.uid.toString(), widget.eventId);

    // ref
    //     .read(eventsByUserProvider(widget.eventId).notifier)
    //     .fetchEvents(sessionVariables.uid.toString());
      
    // ref.read(eventsProvider())
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
