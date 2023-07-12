import 'dart:convert';
import 'dart:io';

import 'package:http/io_client.dart';
import 'package:under_the_c_app/config/session_variables.dart';

void initialiseSessionVariables(String email) async {
  HttpClient client = HttpClient();
  client.badCertificateCallback =
      ((X509Certificate cert, String host, int port) => true);
  var ioClient = IOClient(client);

  final Url = Uri.https(
      '10.0.2.2:7161', '/Authentication/GetInitialData', {'email': email});
  try {
    // if successfully registered then let backend know
    final response = await ioClient.get(Url, headers: {
      "Access-Control-Allow-Origin": "*",
      'Content-Type': 'application/json',
      'Accept': '*/*'
    });

    // handle http response
    if (response.statusCode != 200) {
      throw Exception('GetInitialData API Error: ${response.statusCode}');
    } else {
      // store the user type
      var responseObject = jsonDecode(response.body);
      sessionVariables.sessionIsHost = responseObject['isHost'];
      sessionVariables.email = responseObject['email'];
      sessionVariables.uid = responseObject['uid'];
      print(
          'User type set: ${sessionVariables.sessionIsHost}, User uid: ${sessionVariables.uid}');
    }
  } catch (e) {
    print('$e');
  }
}
