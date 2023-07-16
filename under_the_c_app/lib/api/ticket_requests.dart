import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:under_the_c_app/api/api_routes.dart';

import '../types/tickets/tickets_type.dart';

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
