import 'dart:convert';
import 'package:under_the_c_app/config/session_variables.dart';
import 'package:http/http.dart' as http;
import 'package:under_the_c_app/api/api_routes.dart';
import 'package:under_the_c_app/types/tickets/tickets_type.dart';

import '../types/bookings/booking_type.dart';
import 'converters/booking_converter.dart';

// Gets all tickets for display
Future<List<Tickets>> getTickets(String eventId) async {
  final requestUrl = Uri.https(APIRoutes.BASE_URL, APIRoutes.getTickets,
      {'eventId': eventId, 'customerId': sessionVariables.uid.toString()});

  try {
    final response = await http.get(
      requestUrl,
      headers: APIRoutes.headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      var listOfTickets =
          jsonList.map((json) => Tickets.fromJson(json)).toList();

      return listOfTickets;
    } else {
      throw Exception('GetTickets API ERROR: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception(e);
  }
}

// Gets details of a single ticketS
Future<Tickets> getTicketDetails(String ticketId) async {
  final requestUrl = Uri.https(
      APIRoutes.BASE_URL, APIRoutes.getTicket, {'ticketId': ticketId});

  try {
    final response = await http.get(
      requestUrl,
      headers: APIRoutes.headers,
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonList = jsonDecode(response.body);
      return Tickets.fromJson(jsonList);
    } else {
      throw Exception('GetTicketDetails API ERROR: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception(e);
  }
}

// Creates a new ticket for an event (for hosts to use)
Future<void> createTickets(
    Map<String, dynamic> ticketData, String eventId) async {
  final requestUrl = Uri.https(APIRoutes.BASE_URL, APIRoutes.createTickets);

  Map<String, dynamic> jsonBody = {
    'price': int.parse(ticketData['price']),
    'name': ticketData['name'],
    'eventId': int.parse(eventId),
    'stock': int.parse(ticketData['amount']),
    'availableTime': ticketData['availableTime']
  };

  try {
    final response = await http.post(
      requestUrl,
      headers: APIRoutes.headers,
      body: jsonEncode(jsonBody),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(response.body);
    }
  } catch (e) {
    throw Exception(e);
  }
}

// Request made by hosts to delete tickets from event
Future<void> deleteTickets(int ticketId) async {
  final requestUrl = Uri.https(APIRoutes.BASE_URL, APIRoutes.deleteTickets);
  try {
    final response = await http.delete(
      requestUrl,
      headers: APIRoutes.headers,
      body: jsonEncode({
        "ticketId": ticketId,
      }),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(response.body);
    }
  } catch (e) {
    throw Exception(e);
  }
}

// Request used by users to purchase their selected tickets
Future<UserBooking?> purchaseTickets(Map<int, int> selectedTickets) async {
  final bookTicketUrl = Uri.https(APIRoutes.BASE_URL, APIRoutes.bookTickets);

  Map<String, dynamic> jsonBody = {
    'customerId': sessionVariables.uid,
    'bookingTickets': selectedTickets.map(
      (key, value) => MapEntry(key.toString(), value),
    ),
    'paymentMethod': 1
  };

  try {
    final response = await http.post(
      bookTicketUrl,
      headers: {
        'Content-Type': 'application/json',
        'Accept': '*/*',
      },
      body: jsonEncode(jsonBody),
    );

    // handle http response
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonList = jsonDecode(response.body);
      return addBackendBooking(jsonList);
    } else if (response.statusCode == 500) {
      return null;
    } else {
      throw Exception('API Error: $response');
    }
  } catch (e) {
    print('$e');
    throw Exception(e);
  }
}
