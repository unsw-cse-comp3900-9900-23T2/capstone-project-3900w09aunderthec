import 'dart:convert';
import 'package:under_the_c_app/config/session_variables.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:under_the_c_app/api/api_routes.dart';
import 'package:under_the_c_app/types/tickets/tickets_type.dart';
import '../components/ticket/book_ticket.dart';

Future<List<Tickets>> getTickets(String eventId) async {
  final requestUrl =
      Uri.https(APIRoutes.BASE_URL, APIRoutes.getTickets, {'eventId': eventId});

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

void purchaseTickets() async {
  final bookTicketUrl = Uri.https(APIRoutes.BASE_URL, APIRoutes.bookTickets);
  final container = ProviderContainer();
  var selectedTickets = container.read(selectedTicketsProvider);

  Map<String, dynamic> jsonBody = {
    'uid': sessionVariables.uid,
    'tickets': selectedTickets
  };

  try {
    final response = await http.post(
      bookTicketUrl,
      headers: {
        "Access-Control-Allow-Origin": "*",
        'Content-Type': 'application/json',
        'Accept': '*/*'
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
