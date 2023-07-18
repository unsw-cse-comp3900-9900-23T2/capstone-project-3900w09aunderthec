import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:under_the_c_app/api/comment_requests.dart';
import 'package:under_the_c_app/types/events/comment_type.dart';

class CommentsProvider extends StateNotifier<List<CommentT>> {
  List<CommentT> _allEvents;
  String eventId;

  // final bool isHost;
  CommentsProvider(this.eventId)
      : _allEvents = [],
        super([]) {
    fetchComments();
  }

  Future<void> addComment({String? commentId, required String comment}) async {
    CommentT newComment =
        await createComment(eventId, commentId: commentId, comment: comment);

    state = [...state, newComment];
    _allEvents = [..._allEvents, newComment];
  }

  Future<void> fetchComments() async {
    state = await getAllComments(eventId);
    setEvents(state);
  }

  void setEvents(List<CommentT> events) {
    _allEvents = events;
    state = events;
  }

  void reset() {
    state = _allEvents;
  }
}

final commentsProvider =
    StateNotifierProvider.family<CommentsProvider, List<CommentT>, String>(
        (ref, eventId) => CommentsProvider(eventId));
