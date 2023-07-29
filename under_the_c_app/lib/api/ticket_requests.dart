import 'dart:convert';
import 'package:under_the_c_app/config/session_variables.dart';
import 'package:http/http.dart' as http;
import 'package:under_the_c_app/api/api_routes.dart';
import 'package:under_the_c_app/types/tickets/tickets_type.dart';

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
      return jsonList.map((json) => Tickets.fromJson(json)).toList();
    } else {
      throw Exception('GetTickets API ERROR: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception(e);
  }
}

Future<void> createTickets(
    Map<String, dynamic> ticketData, String eventId) async {
  final requestUrl = Uri.https(APIRoutes.BASE_URL, APIRoutes.createTickets);

  Map<String, dynamic> jsonBody = {
    'price': int.parse(ticketData['price']),
    'name': ticketData['name'],
    'eventId': int.parse(eventId),
    'stock': int.parse(ticketData['amount']),
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

void purchaseTickets(Map<int, int> selectedTickets) async {
  final bookTicketUrl = Uri.https(APIRoutes.BASE_URL, APIRoutes.bookTickets);

  Map<String, dynamic> jsonBody = {
    'customerId': sessionVariables.uid,
    'bookingTickets': selectedTickets.map(
      (key, value) => MapEntry(key.toString(), value),
    ),
    'paymentMethod': 0
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
    if (response.statusCode != 200) {
      throw Exception('API Error: $response');
    }
  } catch (e) {
    print('$e');
  }
}
