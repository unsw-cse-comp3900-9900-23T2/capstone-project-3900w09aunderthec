import 'dart:convert';
import 'dart:io';

import 'api_routes.dart';
import 'package:http/http.dart' as http;

Future<List<int>> getEventsYearlyDistributionAPI(String uid) async {
  final registerUrl =
      Uri.https(APIRoutes.BASE_URL, APIRoutes.getEventsYearlyDistribution, {"hosterId":uid});
  try {
    final response = await http.get(
      registerUrl,
      headers: APIRoutes.headers,
    );

    if (response.statusCode == 200) {
      // final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      final List<int> data = List<int>.from(jsonDecode(response.body));
      return data;
    } else {
      throw Exception(
          'analytics.dart.getEventsYearlyDistributionAPI: Server returned status code ${response.statusCode}');
    }
  } on SocketException catch (e) {
    throw Exception(
        'analytics.dart.getEventsYearlyDistributionAPI: Network error $e');
  } on HttpException catch (e) {
    throw Exception(
        'analytics.dart.getEventsYearlyDistributionAPI: Http Exception error $e');
  } catch (e) {
    throw Exception(
        'analytics.dart.getEventsYearlyDistributionAPI: Unknown error $e');
  }
}
