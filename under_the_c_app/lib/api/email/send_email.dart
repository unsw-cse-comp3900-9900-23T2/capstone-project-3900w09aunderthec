import 'dart:convert';
import 'dart:io';

import 'package:http/io_client.dart';
import 'package:under_the_c_app/config/session_variables.dart';

void sendEmail() async {
  HttpClient client = HttpClient();
  client.badCertificateCallback =
      ((X509Certificate cert, String host, int port) => true);
  var ioClient = IOClient(client);

  final Url = Uri.https('10.0.2.2:7161', '/api/Booking/MakeBooking');

  try {
    // if successfully registered then let backend know
    final response = await ioClient.post(
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
