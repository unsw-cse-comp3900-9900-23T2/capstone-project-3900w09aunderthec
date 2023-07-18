// import 'package:under_the_c_app/api/api_routes.dart';
// import 'package:under_the_c_app/components/events/event_details/comment/comment.dart';
// import 'package:http/http.dart' as http;

// Future<List<Comment>> getAllComments() async {
//   final registerUrl = Uri.https(APIRoutes.BASE_URL, APIRoutes.getComments);
//   try {
//     final response = await http.get(
//       registerUrl,
//       headers: APIRoutes.headers,
//     );

//     if (response.statusCode == 200) {
//       final List<dynamic> jsonList = jsonDecode(response.body);
//       final List<BackendEventData> events =
//           jsonList.map((json) => BackendEventData.fromJson(json)).toList();
//       return BackendDataEventListToEvent(events);
//     } else {
//       throw Exception(
//           'event.dart.getEvents: Server returned status code ${response.statusCode}');
//     }
//   } on SocketException catch (e) {
//     throw Exception('event.dart.getAllEvents: Network error $e');
//   } on HttpException catch (e) {
//     throw Exception('event.dart.getAllEvents: Http Exception error $e');
//   } catch (e) {
//     throw Exception('event.dart.getAllEvents: Unknown error $e');
//   }
// }