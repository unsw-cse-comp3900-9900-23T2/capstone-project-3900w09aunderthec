import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:under_the_c_app/components/ticket/book_ticket.dart';
import 'package:under_the_c_app/config/session_variables.dart';
import 'api_routes.dart';

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
