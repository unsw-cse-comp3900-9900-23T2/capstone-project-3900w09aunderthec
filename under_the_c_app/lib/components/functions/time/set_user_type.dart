import 'dart:convert';
import 'dart:io';

import 'package:http/io_client.dart';
import 'package:under_the_c_app/config/session_variables.dart';
import 'package:under_the_c_app/main.dart';

void initialiseSessionVariables(String email) async {
  HttpClient client = HttpClient();
  client.badCertificateCallback =
      ((X509Certificate cert, String host, int port) => true);
  var ioClient = IOClient(client);

  final Url = Uri.https(
      '10.0.2.2:7161', '/Authentication/GetUserType', {'email': email});
  try {
    // if successfully registered then let backend know
    final response = await ioClient.get(Url, headers: {
      "Access-Control-Allow-Origin": "*",
      'Content-Type': 'application/json',
      'Accept': '*/*'
    });

    // handle http response
    if (response.statusCode != 200) {
      throw Exception('API Error: ${response}');
    } else {
      // store the user type
      sessionVariables.sessionIsHost = jsonDecode(response.body);
      print('User type set: ${sessionVariables.sessionIsHost}');
    }
  } catch (e) {
    print('$e');
  }
}
