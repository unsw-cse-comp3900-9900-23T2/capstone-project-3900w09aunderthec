import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:under_the_c_app/api/user_request.dart';
import 'package:under_the_c_app/providers/comment_providers.dart';
import 'package:under_the_c_app/types/events/comment_type.dart';
import 'package:under_the_c_app/types/users/customer_type.dart';

class CommentCard extends ConsumerStatefulWidget {
  final CommentT comment;
  const CommentCard({required this.comment, super.key});

  @override
  CommentCardState createState() => CommentCardState();
}

class CommentCardState extends ConsumerState<CommentCard> {
  bool thumbLikeSelected = false;
  bool thumbDislikeSelected = false;
  bool commentSelected = false;
  Future<Customer>? customerFuture;

  @override
  initState() {
    super.initState();
    customerFuture = fetchCustomerData();
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

  void toggleThumbLike() {
    setState(() {
      // initailize once only
      if (!thumbLikeSelected) {
        ref
            .read(commentsProvider(widget.comment.eventId).notifier)
            .likeComment(widget.comment.id!);
      }
      thumbLikeSelected = true;
    });
  }

  void toggleThumbDislike() {
    setState(() {
      if (!thumbDislikeSelected) {
        ref
            .read(commentsProvider(widget.comment.eventId).notifier)
            .dislikeComment(widget.comment.id!);
      }
      thumbDislikeSelected = true;
    });
  }

  void toggleComment() {
    setState(() {
      commentSelected = !commentSelected;
    });
  }

  @override
  Widget build(BuildContext context) {
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
                      children: [
                        const CircleAvatar(
                          backgroundImage: AssetImage("images/users/guy.jpg"),
                          radius: 25,
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(customer.userName),
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
                              icon: Icon(thumbLikeSelected
                                  ? Icons.thumb_up
                                  : Icons.thumb_up_alt_outlined),
                              color: thumbLikeSelected
                                  ? const Color.fromARGB(255, 255, 17, 0)
                                  : Colors.grey,
                            ),
                            Text(widget.comment.nLikes.toString(),
                                style: const TextStyle(color: Colors.grey))
                          ],
                        ),
                        const SizedBox(width: 12),
                        Row(
                          children: [
                            IconButton(
                              onPressed: () => {
                                toggleThumbDislike(),
                              },
                              icon: Icon(thumbDislikeSelected
                                  ? Icons.thumb_down
                                  : Icons.thumb_down_alt_outlined),
                              color: thumbDislikeSelected
                                  ? Colors.blue
                                  : Colors.grey,
                            ),
                            Text(widget.comment.nDislikes.toString(),
                                style: const TextStyle(color: Colors.grey))
                          ],
                        ),
                        const SizedBox(width: 12),
                        Row(
                          children: [
                            IconButton(
                                onPressed: () => {toggleComment()},
                                icon: Icon(commentSelected
                                    ? Icons.comment
                                    : Icons.comment_outlined),
                                color: commentSelected
                                    ? const Color.fromARGB(255, 149, 37, 176)
                                    : Colors.grey),
                            // Text("$nComment", style: TextStyle(color: Colors.grey))
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ),
            );
          }
        });
  }
}
