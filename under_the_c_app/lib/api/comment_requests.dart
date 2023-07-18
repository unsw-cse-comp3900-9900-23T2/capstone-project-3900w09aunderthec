import 'dart:convert';
import 'dart:io';
import 'package:under_the_c_app/config/session_variables.dart';
import 'package:under_the_c_app/api/api_routes.dart';
import 'package:under_the_c_app/api/converters/comment_converter.dart';
import 'package:http/http.dart' as http;
import 'package:under_the_c_app/types/events/comment_type.dart';

Future<List<CommentT>> getAllComments(String eventId) async {
  final registerUrl = Uri.https(
      APIRoutes.BASE_URL, APIRoutes.getComments, {"eventId": eventId});
  try {
    final response = await http.get(
      registerUrl,
      headers: APIRoutes.headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      final List<CommentT> events = jsonList
          .map((json) => backendDataSingleCommentToComment(json))
          .toList();
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
      return backendDataSingleCommentToComment(data);
    } else {
      throw Exception(response.body);
    }
  } on SocketException catch (e) {
    throw Exception('event.dart.createEvent: Network error $e');
  } on HttpException catch (e) {
    throw Exception('event.dart.createEvent: Http Exception error $e');
  } catch (e) {
    throw Exception('event.dart.createEvent: Unknown error $e');
  }
}