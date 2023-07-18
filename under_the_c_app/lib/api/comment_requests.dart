import 'dart:convert';
import 'dart:io';

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
      return backendDataCommentListToComment(events);
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
