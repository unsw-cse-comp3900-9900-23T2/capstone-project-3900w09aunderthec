import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:under_the_c_app/api/api_routes.dart';
import 'package:under_the_c_app/types/tickets/tickets_type.dart';

Future<List<Tickets>> getTickets(String eventId) async {
  final requestUrl = Uri.https(APIRoutes.BASE_URL, APIRoutes.getTickets);

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

Future<void> createTickets(Tickets newTicket, int stock) async {
  final requestUrl = Uri.https(APIRoutes.BASE_URL, APIRoutes.createTickets);
  try {
    final response = await http.post(
      requestUrl,
      headers: APIRoutes.headers,
      body: jsonEncode({
        "price": newTicket.price.toInt(),
        "name": newTicket.name,
        "eventId": newTicket.eventIdRef,
        "stock": stock
      }),
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
