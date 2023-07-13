import 'dart:convert';
import 'package:under_the_c_app/config/session_variables.dart';
import 'package:http/http.dart' as http;

void sendEmail() async {
  final Url = Uri.https('10.0.2.2:7161', '/api/Booking/MakeBooking');

  try {
    final response = await http.post(
      Url,
      headers: {
        "Access-Control-Allow-Origin": "*",
        'Content-Type': 'application/json',
        'Accept': '*/*'
      },
      body: jsonEncode({'email': sessionVariables.email}),
    );

    // handle http response
    if (response.statusCode != 200) {
      throw Exception('API Error: ${response}');
    }
  } catch (e) {
    print('$e');
  }
}
