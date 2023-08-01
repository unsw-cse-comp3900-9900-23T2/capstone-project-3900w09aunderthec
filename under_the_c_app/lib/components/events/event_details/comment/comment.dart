import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:under_the_c_app/api/comment_requests.dart';
import 'package:under_the_c_app/components/events/event_details/comment/comment_card.dart';
import 'package:under_the_c_app/providers/comment_providers.dart';
import 'package:under_the_c_app/providers/user_providers.dart';
import 'package:under_the_c_app/types/events/comment_type.dart';

import 'comment_filter.dart';

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
    // fetch updated comments when just going to the page
    ref.read(commentsProvider(widget.eventId).notifier).fetchComments();
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
    final user = ref.watch(userProvider);
    var column = Column(
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
                  Text(
                    user?.userName ?? "Me",
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.public,
                        size: 17,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 5),
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
        TextField(
          controller: commentController,
          focusNode: _commentFocusNode,
          maxLines: null,
          decoration: const InputDecoration(
            hintText: 'What do you want to talk about?',
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 3),
          ),
        ),
        if (_commentFocusNode.hasFocus)
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: ElevatedButton(
              onPressed: () async {
                await ref
                    .read(commentsProvider(widget.eventId).notifier)
                    .addComment(comment: commentController.text);

                // clear the text field and unfocus the text field to hide keyboard
                commentController.clear();
                _commentFocusNode.unfocus();
              },
              child: const Text("Submit"),
            ),
          )
      ],
    );
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
        // "What do you want to talk about" section
        column,
        const SizedBox(height: 30),
        //  a list of comments section
        CommentFilter(eventId: widget.eventId),
        Column(
          children: [
            ...comments
                .map((CommentT comment) => Padding(
                      key: ValueKey(comment.id),
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: CommentCard(
                        comment: comment,
                      ),
                    ))
                .toList()
          ],
        ),
        // make sure there's enough space when there's no comment
        _commentFocusNode.hasFocus ? const SizedBox(height: 180) : Container()
      ],
    );
  }
}
