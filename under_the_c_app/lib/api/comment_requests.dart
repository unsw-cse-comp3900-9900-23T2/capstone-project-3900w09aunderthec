import 'dart:convert';
import 'dart:io';
import 'package:under_the_c_app/config/session_variables.dart';
import 'package:under_the_c_app/api/api_routes.dart';
import 'package:under_the_c_app/api/converters/comment_converter.dart';
import 'package:http/http.dart' as http;
import 'package:under_the_c_app/types/events/comment_type.dart';

Future<List<CommentT>> getAllComments(String eventId,
    {String? sortby = 'soonest'}) async {
  final registerUrl = Uri.https(APIRoutes.BASE_URL, APIRoutes.getComments,
      {"eventId": eventId, "sortby": sortby});
  try {
    final response = await http.get(
      registerUrl,
      headers: APIRoutes.headers,
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      final List<dynamic> jsonPinnedCommentsList =
          jsonResponse['pinnedComments'];
      final List<dynamic> jsonCommentsList = jsonResponse['comments'];

      // add all pinned comments
      final List<CommentT> events = jsonPinnedCommentsList
          .where((json) => json['replyTo'] == null)
          .map((json) => backendDataSinglePinnedCommentToComment(json))
          .toList();

      // add all other comments
      events.addAll(jsonCommentsList
          .where((json) => json['replyTo'] == null)
          .map((json) => backendDataSingleUnpinnedCommentToComment(json)));

      return events;
    } else {
      throw Exception(
          'comment.dart.getEvents: Server returned status code ${response.statusCode}');
    }
  } on SocketException catch (e) {
    throw Exception('comment.dart.getAllcomments: Network error $e');
  } on HttpException catch (e) {
    throw Exception('comment.dart.getAllcomments: Http Exception error $e');
  } catch (e) {
    throw Exception('comment.dart.getAllcomments: Unknown error $e');
  }
}

Future<List<CommentT>> getRepliesAPI(String commentId, {String? sortby}) async {
  final registerUrl = Uri.https(APIRoutes.BASE_URL, APIRoutes.getComments,
      {"sortby": sortby, "replyToComment": commentId});
  try {
    final response = await http.get(
      registerUrl,
      headers: APIRoutes.headers,
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      final List<dynamic> jsonPinnedCommentsList =
          jsonResponse['pinnedComments'];
      final List<dynamic> jsonCommentsList = jsonResponse['comments'];

      // add all pinned replies
      final List<CommentT> events = jsonPinnedCommentsList
          // .where((element) => element['replyTo'] != null)
          .map((json) => backendDataSinglePinnedCommentToComment(json))
          .toList();

      // add all other replies
      events.addAll(jsonCommentsList
          // .where((element) => element['replyTo'] != null)
          .map((json) => backendDataSingleUnpinnedCommentToComment(json)));

      return events;
    } else {
      throw Exception(
          'comment.dart.getEvents: Server returned status code ${response.statusCode}');
    }
  } on SocketException catch (e) {
    throw Exception('comment.dart.getAllcomments: Network error $e');
  } on HttpException catch (e) {
    throw Exception('comment.dart.getAllcomments: Http Exception error $e');
  } catch (e) {
    throw Exception('comment.dart.getAllcomments: Unknown error $e');
  }
}

Future<CommentT> createComment(String eventId,
    {String? commentId, required String comment}) async {
  final uid = sessionVariables.uid;
  final url = Uri.https(APIRoutes.BASE_URL, APIRoutes.createComment);
  try {
    final response = await http.post(
      url,
      headers: APIRoutes.headers,
      body: jsonEncode(
        {
          "commenterId": uid,
          "eventId": eventId,
          "commentId": commentId,
          "comment": comment,
        },
      ),
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return backendDataSingleUnpinnedCommentToComment(data);
    } else {
      throw Exception(response.body);
    }
  } on SocketException catch (e) {
    throw Exception('comment.dart.createcomment: Network error $e');
  } on HttpException catch (e) {
    throw Exception('comment.dart.createcomment: Http Exception error $e');
  } catch (e) {
    throw Exception('comment.dart.createcomment: Unknown error $e');
  }
}

Future<void> likeCommentAPI(String commentId) async {
  final uid = sessionVariables.uid;
  final url = Uri.https(APIRoutes.BASE_URL, APIRoutes.likeComment);
  try {
    final response = await http.post(
      url,
      headers: APIRoutes.headers,
      body: jsonEncode(
        {
          "customerId": uid,
          "commentId": commentId,
        },
      ),
    );
    if (response.statusCode != 200) {
      throw Exception(response.body);
    }
  } on SocketException catch (e) {
    throw Exception('comment.dart.likecomment: Network error $e');
  } on HttpException catch (e) {
    throw Exception('comment.dart.likecomment: Http Exception error $e');
  } catch (e) {
    throw Exception('comment.dart.likecomment: Unknown error $e');
  }
}

Future<void> dislikeCommentAPI(String commentId) async {
  final uid = sessionVariables.uid;
  final url = Uri.https(APIRoutes.BASE_URL, APIRoutes.dislikeComment);
  try {
    final response = await http.post(
      url,
      headers: APIRoutes.headers,
      body: jsonEncode(
        {
          "customerId": uid,
          "commentId": commentId,
        },
      ),
    );
    if (response.statusCode != 200) {
      throw Exception(response.body);
    }
  } on SocketException catch (e) {
    throw Exception('comment.dart.likecomment: Network error $e');
  } on HttpException catch (e) {
    throw Exception('comment.dart.likecomment: Http Exception error $e');
  } catch (e) {
    throw Exception('comment.dart.likecomment: Unknown error $e');
  }
}

Future<bool> isLikeCommentAPI(String uid, String commentId) async {
  final url = Uri.https(APIRoutes.BASE_URL, APIRoutes.isLikeComment,
      {"uid": uid, "commentId": commentId});
  try {
    final response = await http.get(
      url,
      headers: APIRoutes.headers,
    );
    if (response.statusCode == 200) {
      return response.body.toLowerCase() == 'true';
    } else {
      throw Exception(response.body);
    }
  } on SocketException catch (e) {
    throw Exception('comment.dart.isLikeComment: Network error $e');
  } on HttpException catch (e) {
    throw Exception('comment.dart.isLikeComment: Http Exception error $e');
  } catch (e) {
    throw Exception('comment.dart.isLikeComment: Unknown error $e');
  }
}

Future<bool> isDislikeCommentAPI(String uid, String commentId) async {
  final url = Uri.https(APIRoutes.BASE_URL, APIRoutes.isDislikeComment,
      {"uid": uid, "commentId": commentId});
  try {
    final response = await http.get(
      url,
      headers: APIRoutes.headers,
    );
    if (response.statusCode == 200) {
      return response.body.toLowerCase() == 'true';
    } else {
      throw Exception(response.body);
    }
  } on SocketException catch (e) {
    throw Exception('comment.dart.isDislikeComment: Network error $e');
  } on HttpException catch (e) {
    throw Exception('comment.dart.isDislikeComment: Http Exception error $e');
  } catch (e) {
    throw Exception('comment.dart.isDislikeComment: Unknown error $e');
  }
}

Future<CommentT> pinCommentAPI(String commentId) async {
  final url = Uri.https(APIRoutes.BASE_URL, APIRoutes.pinComment);
  try {
    final response = await http.post(
      url,
      headers: APIRoutes.headers,
      body: jsonEncode(
        {
          "commentId": commentId,
        },
      ),
    );
    if (response.statusCode != 200) {
      throw Exception(response.body);
    } else {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return backendDataSingleCommentToComment(data);
    }
  } on SocketException catch (e) {
    throw Exception('comment.dart.pinComment: Network error $e');
  } on HttpException catch (e) {
    throw Exception('comment.dart.pinComment: Http Exception error $e');
  } catch (e) {
    throw Exception('comment.dart.pinComment: Unknown error $e');
  }
}
