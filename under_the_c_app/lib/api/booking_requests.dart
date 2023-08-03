import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:under_the_c_app/api/api_routes.dart';

import '../types/bookings/booking_type.dart';
import 'converters/booking_converter.dart';

// Get all bookings
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
      return getAllBackendBooking(jsonList);
    } else {
      throw Exception('GetBookings API ERROR: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception(e);
  }
}

// Get detail of specific booking
Future<BookingDetails> getBookingDetails(String bookingId) async {
  final requestUrl = Uri.https(APIRoutes.BASE_URL,
      APIRoutes.getBookingDetail(bookingId), {'bookingId': bookingId});

  try {
    final response = await http.get(
      requestUrl,
      headers: APIRoutes.headers,
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonList = jsonDecode(response.body);
      return getBackendBookingDetails(jsonList);
    } else {
      throw Exception('GetBookingDetails API ERROR: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception(e);
  }
}

// Cancel booking
Future<UserBooking?> cancelBooking(int bookingId) async {
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
      // 200 Success
      Map<String, dynamic> jsonList = jsonDecode(response.body);
      UserBooking isRefundable = removeBackendBooking(jsonList);
      return isRefundable;
    } else if (response.statusCode == 400) {
      // 400 Cancellation requests must be made at least 7 days prior to the event.
      return null;
    } else {
      // 404 no relevant booking tickets found
      // Can't do just throw exception, need to warn customers that tickets are non-refundable if it fails
      throw Exception(response.body);
    }
  } on SocketException catch (e) {
    throw Exception('view_booking.dart.removeBooking: Network error $e');
  } on HttpException catch (e) {
    throw Exception('view_booking.dart.removeBooking: Http Exception error $e');
  } catch (e) {
    throw Exception('view_booking.dart.removeBooking: Unknown error $e');
  }
}
