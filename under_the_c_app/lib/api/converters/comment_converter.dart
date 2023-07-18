import 'package:under_the_c_app/types/events/comment_type.dart';

List<CommentT> backendDataCommentListToComment(data) {
  List<CommentT> comments = [];
  for (var comment in data) {
    comment.add(
      CommentT(
        content: comment.comment,
        commentId: comment.id.toString(),
        uid: comment.customerId.toString(),
        replyToId: comment.inReplyTo.toString(),
        nLikes: comment.nLikes,
        nDislikes: comment.nDislikes,
        createdTime: DateTime.parse(comment.createdTime),
      ),
    );
  }
  return comments;
}

//   return CommentT(
CommentT backendDataSingleCommentToComment(data) {
  return CommentT(
    content: data['comment'],
    commentId: data['id'].toString(),
    uid: data['customerId'].toString(),
    replyToId: data['inReplyTo'].toString(),
    nLikes: data['nLikes'],
    nDislikes: data['nDislikes'],
    createdTime: DateTime.parse(data['createdTime']),
  );
}
