import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:under_the_c_app/api/api_routes.dart';
import 'package:under_the_c_app/api/converters/event_converter.dart';
import 'package:under_the_c_app/config/session_variables.dart';
import 'package:under_the_c_app/types/events/event_type.dart';

Future<List<Event>> getEvents(bool isHost) async {
  final registerUrl = isHost == false
      ? Uri.https(APIRoutes.BASE_URL, APIRoutes.getEvents)
      : Uri.https(APIRoutes.BASE_URL, APIRoutes.getEvents, {'hostId': sessionVariables.uid});
  try {
    final response = await http.get(
      registerUrl,
      headers: APIRoutes.headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      final List<BackendEventData> events =
          jsonList.map((json) => BackendEventData.fromJson(json)).toList();
      return BackendDataEventListToEvent(events);
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

Future<Event> getEvent(String id) async {
  final url =
      Uri.https(APIRoutes.BASE_URL, APIRoutes.getEventDetails, {"eventId": id});

  try {
    final response = await http.get(url, headers: APIRoutes.headers);
    if (response.statusCode == 200) {
      final Map<String, dynamic>  data = jsonDecode(response.body);
      return BackendDataSingleEventToEvent(data);
    } else {
      throw HttpException('HTTP error: ${response.statusCode}');
    }
  } on SocketException catch (e) {
    throw Exception('event.dart.getEvent: Network error $e');
  } on HttpException catch (e) {
    throw Exception('event.dart.getEvent: Http Exception error $e');
  } catch (e) {
    throw Exception('event.dart.getEvent: Unknown error $e');
  }
}

Future<void> createEvent(Event eventInfo, String uid) async {
  final url = Uri.https(APIRoutes.BASE_URL, APIRoutes.createEvent);
  try {
    final response = await http.post(url,
        headers: APIRoutes.headers,
        body: jsonEncode(
          {
            "uid": 1,
            "title": eventInfo.title,
            "time": "2023-07-14T00:26:39.068Z",
            "venue": eventInfo.address.venue,
            "description": eventInfo.description,
            "allowRefunds": eventInfo.allowRefunds,
            "privateEvent": eventInfo.isPrivate,
            // TODO: [PLHV-200] get_event.dart: So far it only receives tags as sring not list, but we should allow list, go to event_create.dart to modify it
            "tags": "tags"
          },
        ));
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
