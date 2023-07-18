class CommentT {
  final String? commentId;
  final String content;
  final String uid;
  final String eventId;
  final String replyToId;
  final int nLikes;
  final int nDislikes;
  final DateTime createdTime;

  CommentT({
    String? eventId,
    required this.content,
    required this.commentId,
    required this.uid,
    required this.replyToId,
    required this.nLikes,
    required this.nDislikes,
    required this.createdTime,
  }) : eventId = eventId ?? "";
}
