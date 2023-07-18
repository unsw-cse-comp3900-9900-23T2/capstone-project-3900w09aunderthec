import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:under_the_c_app/api/comment_requests.dart';
import 'package:under_the_c_app/types/events/comment_type.dart';

class CommentsProvider extends StateNotifier<List<CommentT>> {
  String eventId;

  // final bool isHost;
  CommentsProvider(this.eventId) : super([]) {
    fetchComments();
  }

  Future<void> addComment({String? commentId, required String comment}) async {
    CommentT newComment =
        await createComment(eventId, commentId: commentId, comment: comment);

    state = [...state, newComment];
  }

  Future<void> fetchComments() async {
    state = await getAllComments(eventId);
    setComments(state);
  }

  void setComments(List<CommentT> comments) {
    state = comments;
  }
}

final commentsProvider =
    StateNotifierProvider.family<CommentsProvider, List<CommentT>, String>(
        (ref, eventId) => CommentsProvider(eventId));
