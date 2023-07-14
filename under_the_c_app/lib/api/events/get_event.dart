import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:under_the_c_app/api/api_routes.dart';
import 'package:under_the_c_app/api/converters/event_converter.dart';
import 'package:under_the_c_app/types/events/event_type.dart';

Future<List<Event>> getEvents(String uid, bool isHost) async {
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
      final List<dynamic> jsonList = jsonDecode(response.body);
      final List<BackendEventData> events =
          jsonList.map((json) => BackendEventData.fromJson(json)).toList();
      return BackendDataToEvent(events);
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
          // {
          //   "uid": 1,
          //   "title": "string",
          //   "time": "2023-07-14T00:26:39.068Z",
          //   "venue": "string",
          //   "description": "string",
          //   "allowRefunds": true,
          //   "privateEvent": true,
          //   "tags": "string"
          // },
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

  // Future<http.Response> createEvent() {
  //   // TODO: Fix datetime
  //   // print(time);
  //   // String formattedDate = DateFormat.yMMMEd().format(time);
  //   // print(formattedDate);
  //   final url = Uri.https('10.0.2.2:7161', '/EventCreation/CreateEvent');
  //   final headers = {'Content-Type': 'application/json'};
  //   final body = jsonEncode({
  //     "uid": 1,
  //     'title': title,
  //     // yyyy-MM-dd HH:mm:ss
  //     // 'time': "2023-06-27 14:56:45",
  //     "time": "2023-06-27T10:15:33.226Z",
  //     'venue': venue,
  //     'description': description,
  //     'allowRefunds': allowRefunds,
  //     'privateEvent': privateEvent,
  //     'tags': tags,
  //   });
  //   return http.post(url, headers: headers, body: body);
  // }