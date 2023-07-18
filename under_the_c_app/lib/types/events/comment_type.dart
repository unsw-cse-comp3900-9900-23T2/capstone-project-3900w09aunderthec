class CommentT {
  final String? id;
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
    required this.id,
    required this.uid,
    required this.replyToId,
    required this.nLikes,
    required this.nDislikes,
    required this.createdTime,
  }) : eventId = eventId ?? "";
}

// class BackendCommentData {
//   final String? commentId;
//   final String content;
//   final String uid;
//   final String eventId;
//   final String replyToId;
//   final int nLikes;
//   final int nDislikes;
//   final DateTime createdTime;

//   BackendCommentData({required this.commentId, required this.content, required this.uid, required this.eventId, required this.replyToId, required this.nLikes, required this.nDislikes, required this.createdTime});
  
//   factory BackendCommentData.fromJson(Map<String, dynamic> json) {
//     return BackendCommentData(
//       commentId: json['id'],
//       eventId: json['eventId'],
//       content: json['hosterId'],
//       uid: json['title'],
//       replyToId: json['venue'],
//       nLikes: json['description'],
//       nDislikes: json['isDirectRefunds'],
//       createdTime: json['isPrivateEvent'],
//     );
//   }

// }
