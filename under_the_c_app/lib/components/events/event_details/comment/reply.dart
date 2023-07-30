import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../providers/comment_providers.dart';

class Reply extends ConsumerWidget {
  final String commentId;
  final String eventId;
  TextEditingController textReplyController = TextEditingController();

  Reply({Key? key, required this.commentId, required this.eventId}) : super(key: key);
  final replyDefaultController =
      TextEditingController(text: "Write something here");

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // fetch replies
    final replies = ref.watch(replyProvider(commentId));

    final screenWidth = MediaQuery.of(context).size.width;
    return Column(
      children: [
        const Divider(),
        // for profile image, name and date of publishing
        Padding(
          padding: const EdgeInsets.only(left: 15.0, top: 10, bottom: 5),
          child: Column(
            children: [
              // Others replies
              ...replies.map((reply) {
                return Column(
                  children: [
                    Row(
                      children: [
                        const CircleAvatar(
                          backgroundImage: AssetImage("images/users/guy.jpg"),
                          radius: 16,
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Text(customer.userName),
                            const Text(
                              "Abraham",
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(height: 4),
                            SizedBox(
                              width: screenWidth * 0.5,
                              child: Text(
                                reply.content,
                                style: const TextStyle(fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                  ],
                );
              }).toList(), // convert the iterable to a list

              // write your reply
              Row(
                children: [
                  const CircleAvatar(
                    backgroundImage: AssetImage("images/users/guy.jpg"),
                    radius: 16,
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Text(customer.userName),
                      const SizedBox(height: 10),
                      const Text(
                        "Me",
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w500),
                      ),

                      /* 
                      The SizedBox widget is used here to limit the width of the TextField.
                      Without a SizedBox or similar, the TextField will try to expand and take up as much space as its parent will allow.
                      By using SizedBox, we're giving the TextField a defined width (and height) so it only takes up that much space.

                      Notice here the Column allows the children to have as much as the width they want, if we don't set a limit on the width
                      of textfield, it will cause overflow.
                      */
                      Row(
                        children: [
                          SizedBox(
                            width: 0.5 * screenWidth,
                            // height: 25,
                            child: TextField(
                              maxLines: null,
                              controller: textReplyController,
                              cursorHeight: 14,
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 12),
                              decoration: const InputDecoration(
                                contentPadding:
                                    EdgeInsets.fromLTRB(20.0, 20.0, 10.0, 0),
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(13.0)),
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(13.0)),
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(13.0)),
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                hintText: "Write something here",
                                hintStyle:
                                    TextStyle(color: Colors.grey, fontSize: 12),
                              ),
                            ),
                          ),
                          // const SizedBox(height: 6),
                          Container(
                            // height: 25,
                            width: 20,
                            child: IconButton(
                                onPressed: () {
                                  ref
                                      .read(replyProvider(commentId).notifier)
                                      .reply(eventId, textReplyController.text);
                                },
                                icon: const Icon(
                                  Icons.send,
                                  color: Colors.purple,
                                )),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
