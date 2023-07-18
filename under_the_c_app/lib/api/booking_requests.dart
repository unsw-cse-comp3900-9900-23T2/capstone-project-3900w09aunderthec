import 'dart:convert';
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
