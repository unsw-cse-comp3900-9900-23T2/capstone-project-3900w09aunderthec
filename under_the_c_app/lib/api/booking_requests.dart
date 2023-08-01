import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:under_the_c_app/api/api_routes.dart';

import '../types/bookings/booking_type.dart';

Future<List<Booking>> getBookings(String uid) async {
  final requestUrl =
      Uri.https(APIRoutes.BASE_URL, APIRoutes.getBooking(uid), {'uid': uid});

  try {
    final response = await http.get(
      requestUrl,
      headers: APIRoutes.headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => Booking.fromJson(json)).toList();
    } else {
      throw Exception('GetBookings API ERROR: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception(e);
  }
}

Future<bool> cancelBooking(int bookingId) async {
  final requestUrl = Uri.https(APIRoutes.BASE_URL, APIRoutes.cancelBooking);

  try {
    final response = await http.delete(
      requestUrl,
      headers: APIRoutes.headers,
      body: jsonEncode(
        {
          "bookingId": bookingId,
        },
      ),
    );

    if (response.statusCode == 200) {
      return true;
    } else if (response.statusCode < 200 || response.statusCode >= 300) {
      return false;
      // throw Exception(response.body);
    }
  } on SocketException catch (e) {
    throw Exception('view_booking.dart.removeBooking: Network error $e');
  } on HttpException catch (e) {
    throw Exception('view_booking.dart.removeBooking: Http Exception error $e');
  } catch (e) {
    throw Exception('view_booking.dart.removeBooking: Unknown error $e');
  }
  return false;
}
