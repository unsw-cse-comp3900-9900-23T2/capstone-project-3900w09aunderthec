// List for Tags
import 'dart:convert';
import 'dart:io';
import '../../../api/api_routes.dart';
import 'package:http/http.dart' as http;

Future<List<String>> getTags(
    String title, String description, String venue) async {
  final registerUrl = Uri.https(APIRoutes.BASE_URL, APIRoutes.getTags,
      {"title": title, "description": description, "venue": venue});
  try {
    final response = await http.get(
      registerUrl,
      headers: APIRoutes.headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return tagsToList(jsonList);
    } else {
      throw Exception(
          'event.dart.getTags: Server returned status code ${response.statusCode}');
    }
  } on SocketException catch (e) {
    throw Exception('event.dart.getTags: Network error $e');
  } on HttpException catch (e) {
    throw Exception('event.dart.getTags: Http Exception error $e');
  } catch (e) {
    throw Exception('event.dart.getTags: Unknown error $e');
  }
}

List<String> tagsToList(data) {
  List<String> events = [];
  for (var event in data) {
    events.add(event);
  }
  return events;
}
