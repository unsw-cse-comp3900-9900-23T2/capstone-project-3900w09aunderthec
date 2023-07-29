import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:under_the_c_app/api/comment_requests.dart';
import 'package:under_the_c_app/components/events/event_details/comment/comment_card.dart';
import 'package:under_the_c_app/providers/comment_providers.dart';
import 'package:under_the_c_app/types/events/comment_type.dart';

class Comment extends ConsumerStatefulWidget {
  final eventId;
  const Comment({required this.eventId, Key? key}) : super(key: key);

  @override
  _CommentState createState() => _CommentState();
}

class _CommentState extends ConsumerState<Comment> {
  final FocusNode _commentFocusNode = FocusNode();
  final TextEditingController commentController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _commentFocusNode.addListener(_handleFocusChange);
  }

  @override
  void dispose() {
    _commentFocusNode.removeListener(_handleFocusChange);
    _commentFocusNode.dispose();
    super.dispose();
  }

  void _handleFocusChange() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final comments = ref.watch(commentsProvider(widget.eventId));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // title
        const Text(
          "Comments",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(221, 5, 5, 5),
          ),
        ),
        const SizedBox(height: 15),
        // "What do you want to talk about" seciton
        Column(
          children: [
            Row(
              children: [
                // for profile picture
                const CircleAvatar(
                  backgroundImage: AssetImage('images/users/guy.jpg'),
                  radius: 25,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0),
                  // for the "name" and "public"
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Ersad Basbag"),
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.public,
                            size: 17,
                            color: Colors.grey[600],
                          ),
                          SizedBox(width: 5),
                          Text(
                            "Public",
                            style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                                letterSpacing: 0.5),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
            // my comment section
            TextField(
              controller: commentController,
              focusNode: _commentFocusNode,
              maxLines: null,
              decoration: const InputDecoration(
                hintText: 'What do you want to talk about?',
                border: InputBorder.none,
                contentPadding:
                    EdgeInsets.symmetric(vertical: 15, horizontal: 3),
              ),
            ),
            if (_commentFocusNode.hasFocus)
              ElevatedButton(
                onPressed: () {
                  ref
                      .read(commentsProvider(widget.eventId).notifier)
                      .addComment(comment: commentController.text);

                  // clear the text field and unfocus the text field to hide keyboard
                  commentController.clear();
                  _commentFocusNode.unfocus();
                },
                child: const Text("Submit"),
              )
          ],
        ),
        Column(
          children: [
            ...comments
                .map((CommentT comment) => Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: CommentCard(comment: comment),
                    ))
                .toList()
          ],
        ),

        // make sure there's enough space when there's no comment
        _commentFocusNode.hasFocus ? SizedBox(height: 180) : Container()
      ],
    );
  }
}
