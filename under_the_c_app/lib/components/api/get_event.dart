import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:under_the_c_app/components/api/api_routes.dart';
import 'package:under_the_c_app/types/events/event_type.dart';

Future<http.Response> getEvents(String uid, bool isHost) async {
  final registerUrl = isHost == false
      ? Uri.https(APIRoutes.BASE_RUL, APIRoutes.getEvents)
      : Uri.https(APIRoutes.BASE_RUL, APIRoutes.getHostEvents);
  try {
    final response = await http.post(
      registerUrl,
      headers: APIRoutes.headers,
      body: jsonEncode(isHost == false ? {"uid": uid} : {"hostId": uid}),
    );

    if (response.statusCode == 200) {
      return response;
    } else {
      throw Exception(
          'event.dart.getEvents: Server returned status code ${response.statusCode}');
    }
  } on SocketException catch (e) {
    throw Exception('event.dart.getEvents: Network error $e');
  } on HttpException catch (e) {
    throw Exception('event.dart.getEvents: Http Exception error $e');
  } catch (e) {
    throw Exception('event.dart.getEvents: Unknown error $e');
  }
}

Future<void> createEvent(Event eventInfo, String uid) async {
  final url = Uri.https(APIRoutes.BASE_RUL, APIRoutes.createEvent);
  try {
    final response = await http.post(url,
        headers: APIRoutes.headers,
        body: jsonEncode({
          "uid": uid,
          "title": eventInfo.title,
          "time": eventInfo.time,
          "venue": eventInfo.address,
          "description": eventInfo.description,
          "allowRefunds": eventInfo.allowRefunds,
          "privateEvent": eventInfo.isPrivate,
          "tags": eventInfo.tags
        }));
    if (response.statusCode < 200 || response.statusCode >= 300) {
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
