import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:under_the_c_app/config/session_variables.dart';

void initialiseSessionVariables(String email) async {
  final Url = Uri.https(
      '10.0.2.2:7161', '/Authentication/GetInitialData', {'email': email});
  try {
    // if successfully registered then let backend know
    final response = await http.get(
      Url,
      headers: {
        "Access-Control-Allow-Origin": "*",
        'Content-Type': 'application/json',
        'Accept': '*/*'
      },
    );

    // handle http response
    if (response.statusCode != 200) {
      throw Exception('GetInitialData API Error: ${response.statusCode}');
    } else {
      // store the user type
      var responseObject = jsonDecode(response.body);
      sessionVariables.sessionIsHost = responseObject['isHost'];
      sessionVariables.email = responseObject['email'];
      sessionVariables.uid = responseObject['uid'];
      sessionVariables.vipLevel = responseObject['vipLevel'];
      sessionVariables.loyaltyPoints = responseObject['loyaltyPoints'];

      print('isHost set: ${sessionVariables.sessionIsHost}');
      print('uid set: ${sessionVariables.uid}');
      print('vipLevel set: ${sessionVariables.vipLevel}');
      print('loyaltyPoints set: ${sessionVariables.loyaltyPoints}');
    }
  } catch (e) {
    print('$e');
  }
}
