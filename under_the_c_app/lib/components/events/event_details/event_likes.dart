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
    getInitialValues();
  }

  // void didUpdateWidget(EventLikes oldWidget) {
  //   super.didUpdateWidget(oldWidget);
  //   if (oldWidget.eventId != widget.eventId) {
  //     setState(() {
  //       if (isLike) {
  //         nLikes += 1;
  //       } else {
  //         nLikes -= 1;
  //       }
  //     });
  //   }
  // }

  Future<void> getInitialValues() async {
    bool isLiked =
        await isEventLikedAPI(sessionVariables.uid.toString(), widget.eventId);
    final event = await getEventDetails(widget.eventId);

    setState(() {
      isLike = isLiked;
      nLikes = event.rating!;
    });
  }

  Future<void> toggleIsLike() async {
    bool updatedLikeStatus = !isLike;

    // Update in the backend first.
    await toggleLikeEventAPI(sessionVariables.uid.toString(), widget.eventId);

    // Then update the UI.
    setState(() {
      isLike = updatedLikeStatus;
      nLikes += updatedLikeStatus ? 1 : -1;
    });

    // trigger the rebuild for the event lists for the future popularity
    ref.read(eventsProvider.notifier).fetchEvents();
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
