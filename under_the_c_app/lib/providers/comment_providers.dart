import 'package:equatable/equatable.dart';
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

  Future<void> likeComment(String commentId) async {
    await likeCommentAPI(commentId); // call the function from your API file
    state = state.map((c) {
      if (c.id == commentId) {
        return CommentT(
            content: c.content,
            id: c.id,
            uid: c.uid,
            replyToId: c.replyToId,
            nLikes: c.nLikes! + 1);
      } else {
        return c;
      }
    }).toList();
  }

  Future<void> dislikeComment(String commentId) async {
    await dislikeCommentAPI(commentId); // call the function from your API file
    // await fetchComments();
  }
}

final commentsProvider =
    StateNotifierProvider.family<CommentsProvider, List<CommentT>, String>(
        (ref, eventId) => CommentsProvider(eventId));

/* Handle like, dislike providers */
class IsLikeCommentParams extends Equatable {
  final String uid;
  final String commentId;
  const IsLikeCommentParams({required this.uid, required this.commentId});

  @override
  List<String> get props => [uid, commentId];
}

final isLikeProvider = FutureProvider.family<bool, IsLikeCommentParams>(
  (ref, isLikeCommentPrams) async {
    final isLike = await isLikeCommentAPI(
        isLikeCommentPrams.uid, isLikeCommentPrams.commentId);
    return isLike;
  },
);
