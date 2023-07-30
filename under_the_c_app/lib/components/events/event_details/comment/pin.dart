import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:under_the_c_app/api/comment_requests.dart';
import 'package:under_the_c_app/providers/comment_providers.dart';

/*
Only the host can pin a comment
Host can view the empty pin, when he clicks on it it will pin the comment.
However, users cannot view the empty pin, but they can view the pinned comments on the top
*/
class Pin extends ConsumerStatefulWidget {
  final bool isOriginalHost;
  final bool isPinned;
  final String commentId;
  const Pin(
      {Key? key,
      required this.isOriginalHost,
      required this.isPinned,
      required this.commentId})
      : super(key: key);

  @override
  ConsumerState<Pin> createState() => _PinState();
}

class _PinState extends ConsumerState<Pin> {
  late bool isPinned;

  void toggleIsPinned() async {
    setState(() {
      isPinned = !isPinned;
    });

    // call pin comment API
    // await pinCommentAPI(widget.commentId);

    // update the order of the comments because of the pin action
    final eventId = ref.watch(eventIdProvider);
    await ref.read(commentsProvider(eventId).notifier).pinComment(widget.commentId);
    ref.read(commentsProvider(eventId).notifier).sortCommentByPin();
  }

  @override
  void initState() {
    super.initState();
    // since the widget has not build yet, we don't use setState here
    isPinned = widget.isPinned;
  }

  @override
  Widget build(BuildContext context) {
    // isPinned = widget.isPinned;
    if (isPinned) {
      if (widget.isOriginalHost) {
        return IconButton(
          onPressed: () => {
            // when unpinning
            toggleIsPinned()
          },
          icon: const Icon(Icons.push_pin_rounded),
        );
      } else {
        return const Icon(Icons.push_pin_rounded);
      }
    } else {
      if (widget.isOriginalHost) {
        return IconButton(
          onPressed: () => {
            //when pin
            toggleIsPinned()
          },
          icon: const Icon(Icons.push_pin_outlined),
        );
      }
      return Container();
    }
  }
}
