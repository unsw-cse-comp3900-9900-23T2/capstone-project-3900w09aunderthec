import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:under_the_c_app/api/user_request.dart';
import 'package:under_the_c_app/components/events/event_details/comment/pin.dart';
import 'package:under_the_c_app/components/events/event_details/comment/reply.dart';
import 'package:under_the_c_app/providers/comment_providers.dart';
import 'package:under_the_c_app/providers/user_providers.dart';
import 'package:under_the_c_app/types/events/comment_type.dart';
import 'package:under_the_c_app/config/session_variables.dart';
import 'package:under_the_c_app/types/users/customer_type.dart';

class CommentCard extends ConsumerStatefulWidget {
  final CommentT comment;
  const CommentCard({required this.comment, super.key});

  @override
  CommentCardState createState() => CommentCardState();
}

class CommentCardState extends ConsumerState<CommentCard> {
  bool likeSelected = false;
  bool replyExpanded = false;
  int nLikes = 0;
  int nDislikes = 0;
  bool dislikeSelected = false;
  Future<Customer>? customerFuture;
  final isHost = sessionVariables.sessionIsHost;
  final uid = sessionVariables.uid;

  @override
  initState() {
    super.initState();
    customerFuture = fetchCustomerData();

    // fetch if it's liked from the db and update in the UI
    ref
        .read(isLikeProvider.notifier)
        .checkIfLiked(uid.toString(), widget.comment.id!)
        .then((val) {
      setState(() {
        likeSelected = val;
        // set nlikes in the UI
        nLikes = widget.comment.nLikes;
      });
    });

    // fetch if it's disliked from the db and update to the UI
    ref
        .read(isDislikeProvider.notifier)
        .checkIfDislike(uid.toString(), widget.comment.id!)
        .then((val) {
      setState(() {
        dislikeSelected = val;
        // set nDislikes in the UI
        nDislikes = widget.comment.nDislikes;
      });
    });
  }

  @override
  void didUpdateWidget(CommentCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.comment != widget.comment) {
      customerFuture = fetchCustomerData();
    }
  }

  Future<Customer> fetchCustomerData() async {
    return await getCustomerById(widget.comment.uid);
  }

  void setLike(bool result) {
    setState(() {
      likeSelected = result;
    });
  }

  void toggleThumbLike() {
    // update in the UI
    setState(
      () {
        likeSelected = !likeSelected;
        // when user clicked like
        if (likeSelected) {
          nLikes += 1;
        } else {
          // when user undo like
          nLikes -= 1;
        }
      },
    );

    // update in the db
    ref
        .read(commentsProvider(widget.comment.eventId).notifier)
        .likeComment(widget.comment.id!);
  }

  void toggleThumbDislike() {
    setState(() {
      // update in the UI
      setState(() {
        dislikeSelected = !dislikeSelected;
        if (dislikeSelected) {
          nDislikes += 1;
        } else {
          nDislikes -= 1;
        }
      });

      // update in the db
      ref
          .read(commentsProvider(widget.comment.eventId).notifier)
          .dislikeComment(widget.comment.id!);
    });
  }

  void toggleComment() {
    setState(() {
      replyExpanded = !replyExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    final originalHostUid = ref.watch(hostUidProvider.notifier).state;
    return FutureBuilder<Customer>(
        future: customerFuture,
        builder: (BuildContext context, AsyncSnapshot<Customer> snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const CircularProgressIndicator(); // show a loading spinner while waiting for data
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}'); // show an error message
          } else {
            Customer customer = snapshot.data!;
            return Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // for profile image, name and date of publishing
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const CircleAvatar(
                              backgroundImage:
                                  AssetImage("images/users/guy.jpg"),
                              radius: 25,
                            ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  customer.userName,
                                  style: const TextStyle(fontSize: 17),
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  "March 24, 15:14",
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                      letterSpacing: 0.4),
                                )
                              ],
                            ),
                          ],
                        ),
                        Pin(
                          isOriginalHost: uid.toString() == originalHostUid,
                          isPinned: widget.comment.isPinned,
                          commentId: widget.comment.id!,
                        )
                      ],
                    ),
                    const SizedBox(height: 15),
                    Text(
                      widget.comment.content,
                      style: const TextStyle(height: 1.25),
                    ),
                    const SizedBox(height: 15),
                    // for like, comment section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            IconButton(
                              onPressed: () => {
                                toggleThumbLike(),
                              },
                              icon: Icon(likeSelected
                                  ? Icons.thumb_up
                                  : Icons.thumb_up_alt_outlined),
                              color: likeSelected ? Colors.red : Colors.grey,
                            ),
                            Text(
                              nLikes.toString(),
                              style: const TextStyle(color: Colors.grey),
                            )
                          ],
                        ),
                        const SizedBox(width: 12),
                        Row(
                          children: [
                            IconButton(
                              onPressed: () => {
                                toggleThumbDislike(),
                              },
                              icon: Icon(dislikeSelected
                                  ? Icons.thumb_down
                                  : Icons.thumb_down_alt_outlined),
                              color:
                                  dislikeSelected ? Colors.blue : Colors.grey,
                            ),
                            Text(nDislikes.toString(),
                                style: const TextStyle(color: Colors.grey))
                          ],
                        ),
                        const SizedBox(width: 12),
                        Row(
                          children: [
                            IconButton(
                                onPressed: () => {toggleComment()},
                                icon: Icon(replyExpanded
                                    ? Icons.comment
                                    : Icons.comment_outlined),
                                color: replyExpanded
                                    ? const Color.fromARGB(255, 149, 37, 176)
                                    : Colors.grey),
                            // Text("$nComment", style: TextStyle(color: Colors.grey))
                          ],
                        )
                      ],
                    ),
                    replyExpanded ? Reply() : Container()
                  ],
                ),
              ),
            );
          }
        });
  }
}
