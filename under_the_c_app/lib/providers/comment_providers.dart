import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:under_the_c_app/api/comment_requests.dart';
import 'package:under_the_c_app/types/events/comment_type.dart';

enum CommentSortQuery { popularity, unpopularity }

enum CommentFilterQuery { pinned, unpinned }

class CommentsProvider extends StateNotifier<List<CommentT>> {
  String eventId;
  List<CommentT> originalUnsortedList = [];

  // final bool isHost;
  CommentsProvider(this.eventId) : super([]) {
    fetchComments();
  }

  Future<void> addComment({String? commentId, required String comment}) async {
    CommentT newComment =
        await createComment(eventId, commentId: commentId, comment: comment);

    List<CommentT> pinnedComments = [];
    List<CommentT> unpinnedComments = [];

    // Sort comments into two lists: one for pinned, one for unpinned
    for (CommentT comment in state) {
      if (comment.isPinned) {
        pinnedComments.add(comment);
      } else {
        unpinnedComments.add(comment);
      }
    }

    // Reconstruct the state list with pinned comments, the new comment, then unpinned comments
    state = []
      ..addAll(pinnedComments)
      ..add(newComment)
      ..addAll(unpinnedComments);

    originalUnsortedList = state;
  }

  void sortCommentByPin() {
    final List<CommentT> sortedPinnedComment = state.toList()
      ..sort(
        (a, b) {
          // Note: The comparison function returns a negative number if 'a' should be before 'b' etc.
          // when b should be in the front
          if (b.isPinned && !a.isPinned) {
            return 1;
          }
          // when b should be in the front
          else if (!b.isPinned && a.isPinned) {
            return -1;
          } else {
            return 0;
          }
        },
      );
    state = sortedPinnedComment;
  }

  void sort(CommentSortQuery query) {
    switch (query) {
      case CommentSortQuery.popularity:
        state = List.from(state)
          ..sort((a, b) {
            // sort in descending order
            if (a.nLikes < b.nLikes) {
              return 1;
            } else if (a.nLikes > b.nLikes) {
              return -1;
            } else {
              return 0;
            }
          });

      case CommentSortQuery.unpopularity:
        state = List.from(state)
          ..sort((a, b) {
            if (a.nDislikes < b.nDislikes) {
              return 1;
            } else if (a.nDislikes > b.nDislikes) {
              return -1;
            } else {
              return 0;
            }
          });
      default:
        break;
    }
  }

  void filter(CommentFilterQuery query) {
    // undo the filter first
    undoSortFilter();
    switch (query) {
      case CommentFilterQuery.pinned:
        state = state.where((element) => element.isPinned == true).toList();

      case CommentFilterQuery.unpinned:
        state = state.where((element) => element.isPinned == false).toList();

      default:
        break;
    }
  }

  void undoSortFilter() {
    state = originalUnsortedList;
  }

  Future<void> pinComment(commentId) async {
    final CommentT newComment = await pinCommentAPI(commentId);
    state = state.map((c) {
      if (c.id == commentId) {
        return CommentT(
            content: newComment.content,
            eventId: newComment.eventId,
            nLikes: newComment.nLikes,
            nDislikes: newComment.nDislikes,
            createdTime: newComment.createdTime,
            id: newComment.id,
            uid: newComment.uid,
            replyToId: newComment.replyToId,
            isPinned: newComment.isPinned);
      } else {
        return c;
      }
    }).toList();
  }

  Future<void> fetchComments() async {
    state = await getAllComments(eventId);
    originalUnsortedList = state;
  }

  Future<void> likeComment(String commentId) async {
    await likeCommentAPI(commentId); // call the function from your API file
  }

  Future<void> dislikeComment(String commentId) async {
    await dislikeCommentAPI(commentId); // call the function from your API file
  }
}

final eventIdProvider = StateProvider((ref) => "");
final commentsProvider =
    StateNotifierProvider.family<CommentsProvider, List<CommentT>, String>(
        (ref, eventId) => CommentsProvider(eventId));

/* fetch replies */
class ReplyProviderNotifier extends StateNotifier<List<CommentT>> {
  final String commentId;
  ReplyProviderNotifier({required this.commentId}) : super([]) {
    fetchAllReplies();
  }

  /* fetch all replies given a comment Id */
  Future<void> fetchAllReplies() async {
    state = await getRepliesAPI(commentId);
  }

  /* Post a reply */
  Future<void> reply(String eventId, String comment) async {
    final newReply =
        await createComment(eventId, commentId: commentId, comment: comment);

    state = [...state, newReply];
  }
}

final replyProvider =
    StateNotifierProvider.family<ReplyProviderNotifier, List<CommentT>, String>(
        (ref, commentId) => ReplyProviderNotifier(commentId: commentId));

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
