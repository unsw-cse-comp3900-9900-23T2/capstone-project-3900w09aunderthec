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
  }

  Future<void> likeComment(String commentId) async {
    await likeCommentAPI(commentId); // call the function from your API file
  }

  Future<void> dislikeComment(String commentId) async {
    await dislikeCommentAPI(commentId); // call the function from your API file
  }
}

final commentsProvider =
    StateNotifierProvider.family<CommentsProvider, List<CommentT>, String>(
        (ref, eventId) => CommentsProvider(eventId));

/* Handle if it's liked providers */
final isLikeProvider =
    StateNotifierProvider<LikeNotifier, bool>((ref) => LikeNotifier());

class LikeNotifier extends StateNotifier<bool> {
  LikeNotifier() : super(false);

  Future<bool> checkIfLiked(String uid, String commentId) async {
    final isLike = await isLikeCommentAPI(uid, commentId);
    state = isLike;
    return isLike;
  }
}

/* Handle if it's disliked provider */
final isDislikeProvider =
    StateNotifierProvider<DislikeNotifier, bool>((ref) => DislikeNotifier());

class DislikeNotifier extends StateNotifier<bool> {
  DislikeNotifier() : super(false);
  Future<bool> checkIfDislike(String uid, String commentId) async {
    final isDislike = await isDislikeCommentAPI(uid, commentId);
    state = isDislike;
    return isDislike;
  }
}
