import 'package:under_the_c_app/types/events/comment_type.dart';

// List<CommentT> backendDataCommentListToComment(data) {
//   List<CommentT> comments = [];
//   for (var comment in data) {
//     comments.add(backendDataSingleCommentToComment(comment)
//         // CommentT(
//         //   content: comment.comment,
//         //   id: comment.id.toString(),
//         //   uid: comment.customerId.toString(),
//         //   replyToId: comment.inReplyTo.toString(),
//         //   nLikes: comment.nLikes,
//         //   nDislikes: comment.nDislikes,
//         //   createdTime: DateTime.parse(comment.createdTime),
//         // ),
//         );
//   }
//   return comments;
// }

//   return CommentT(

CommentT backendDataSingleCommentToComment(data) {
  return CommentT(
    id: data['id'].toString(),
    isPinned: data['isPinned'],
    eventId: data['eventId'].toString(),
    content: data['comment'],
    uid: data['customerId'].toString(),
    replyToId: data['commentId'].toString(),
    nLikes: data['likes'],
    nDislikes: data['dislikes'],
    createdTime: DateTime.parse(data['createdTime']),
  );
}

CommentT backendDataSinglePinnedCommentToComment(data) {
  return CommentT(
    id: data['id'].toString(),
    isPinned: true,
    eventId: data['eventId'].toString(),
    content: data['comment'],
    uid: data['commenteruid'].toString(),
    replyToId: data['commentId'].toString(),
    nLikes: data['likes'],
    nDislikes: data['dislikes'],
    createdTime: DateTime.parse(data['createdTime']),
  );
}

CommentT backendDataSingleUnpinnedCommentToComment(data) {
  return CommentT(
    id: data['id'].toString(),
    isPinned: false,
    eventId: data['eventId'].toString(),
    content: data['comment'],
    uid: data['commenteruid'].toString(),
    replyToId: data['commentId'].toString(),
    nLikes: data['likes'],
    nDislikes: data['dislikes'],
    createdTime: DateTime.parse(data['createdTime']).toLocal(),
  );
}
