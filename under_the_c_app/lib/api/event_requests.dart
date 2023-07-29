import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:under_the_c_app/api/api_routes.dart';
import 'package:under_the_c_app/api/converters/event_converter.dart';
import 'package:under_the_c_app/config/session_variables.dart';
import 'package:under_the_c_app/types/events/event_type.dart';

Future<List<Event>> getAllEvents() async {
  // TODO: [PLHV-203] Event_request.dart: Need to pass variables to getHostEvent, getEvents.
  final registerUrl = Uri.https(APIRoutes.BASE_URL, APIRoutes.getEvents);
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
    throw Exception('event.dart.getAllEvents: Network error $e');
  } on HttpException catch (e) {
    throw Exception('event.dart.getAllEvents: Http Exception error $e');
  } catch (e) {
    throw Exception('event.dart.getAllEvents: Unknown error $e');
  }
}

Future<List<Event>> getUserEvents(String uid,
    {bool? includePastEvents = false}) async {
  final registerUrl = Uri.https(APIRoutes.BASE_URL, APIRoutes.getEvents,
      {'uid': uid, "showPreviousEvents": includePastEvents.toString()});
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
    throw Exception('event.dart.getUserEvents: Network error $e');
  } on HttpException catch (e) {
    throw Exception('event.dart.getUserEvents: Http Exception error $e');
  } catch (e) {
    throw Exception('event.dart.getUserEvents: Unknown error $e');
  }
}

Future<Event> getEventDetails(String id) async {
  final url =
      Uri.https(APIRoutes.BASE_URL, APIRoutes.getEventDetails, {"eventId": id});

  try {
    final response = await http.get(url, headers: APIRoutes.headers);
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
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

Future<Event> createEvent(Event eventInfo) async {
  final uid = sessionVariables.uid;
  final url = Uri.https(APIRoutes.BASE_URL, APIRoutes.createEvent);
  try {
    final response = await http.post(
      url,
      headers: APIRoutes.headers,
      body: jsonEncode(
        {
          "uid": uid,
          "title": eventInfo.title,
          "venue": eventInfo.venue,
          "eventTime": eventInfo.time,
          "description": eventInfo.description,
          "isDirectRefunds": eventInfo.isDirectRefunds,
          "isPrivateEvent": eventInfo.isPrivate,
          // TODO: [PLHV-200] get_event.dart: So far it only receives tags as sring not list, but we should allow list, go to event_create.dart to modify it
          "tags": "tags"
        },
      ),
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return BackendDataSingleEventToEvent(data);
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

Future<void> modifyEvent(Event eventInfo) async {
  final uid = sessionVariables.uid;
  final url = Uri.https(APIRoutes.BASE_URL, APIRoutes.modifyEvent);
  try {
    final response = await http.put(
      url,
      headers: APIRoutes.headers,
      body: jsonEncode(
        {
          "uid": uid,
          "eventId": eventInfo.eventId,
          "title": eventInfo.title,
          "eventTime": eventInfo.time,
          "venue": eventInfo.venue,
          "description": eventInfo.description,
          "isDirectRefunds": eventInfo.isDirectRefunds,
          "isPrivateEvent": eventInfo.isPrivate,
          "tags": "tags",
        },
      ),
    );
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(response.body);
    }
  } on SocketException catch (e) {
    throw Exception('event.dart.modifyEvent: Network error $e');
  } on HttpException catch (e) {
    throw Exception('event.dart.modifyEvent: Http Exception error $e');
  } catch (e) {
    throw Exception('event.dart.modifyEvent: Unknown error $e');
  }
}

Future<void> cancelEvent(Event eventInfo) async {
  final url = Uri.https(APIRoutes.BASE_URL, APIRoutes.cancelEvent);
  try {
    final response = await http.delete(
      url,
      headers: APIRoutes.headers,
      body: jsonEncode(
        {
          "eventId": eventInfo.eventId,
        },
      ),
    );
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(response.body);
    }
  } on SocketException catch (e) {
    throw Exception('event.dart.cancelEvent: Network error $e');
  } on HttpException catch (e) {
    throw Exception('event.dart.cancelEvent: Http Exception error $e');
  } catch (e) {
    throw Exception('event.dart.cancelEvent: Unknown error $e');
  }
}

Future<void> sendNotification(
    Map<String, dynamic> notificationData, int eventId) async {
  final url = Uri.https(APIRoutes.BASE_URL, APIRoutes.emailNotification);

  Map<String, dynamic> jsonBody = {
    'eventId': eventId,
    'subject': notificationData['subject'],
    'body': notificationData['body']
  };

  try {
    final response = await http.post(
      url,
      headers: APIRoutes.headers,
      body: jsonEncode(jsonBody),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(response.body);
    }
  } on SocketException catch (e) {
    throw Exception('event.dart.cancelEvent: Network error $e');
  } on HttpException catch (e) {
    throw Exception('event.dart.cancelEvent: Http Exception error $e');
  } catch (e) {
    throw Exception('event.dart.cancelEvent: Unknown error $e');
  }
}
