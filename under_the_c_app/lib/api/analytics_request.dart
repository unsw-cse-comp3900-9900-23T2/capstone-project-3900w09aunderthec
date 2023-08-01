import 'dart:convert';
import 'dart:io';

import 'api_routes.dart';
import 'package:http/http.dart' as http;

Future<List<int>> getEventsYearlyDistributionAPI(String uid) async {
  final registerUrl = Uri.https(APIRoutes.BASE_URL,
      APIRoutes.getEventsYearlyDistribution, {"hosterId": uid});
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

Future<int> getNumberOfEventsHosted(String uid) async {
  final registerUrl = Uri.https(
      APIRoutes.BASE_URL, APIRoutes.getNumberEventsHosted, {"hosterId": uid});
  try {
    final response = await http.get(
      registerUrl,
      headers: APIRoutes.headers,
    );

    if (response.statusCode == 200) {
      final int data = int.parse(response.body);
      return data;
    } else {
      throw Exception(
          'analytics.dart.getEventsYearlyDistributionAPI: Server returned status code ${response.statusCode}');
    }
  } on SocketException catch (e) {
    throw Exception('analytics.dart.getNumberOfEventsHosted: Network error $e');
  } on HttpException catch (e) {
    throw Exception(
        'analytics.dart.getNumberOfEventsHosted: Http Exception error $e');
  } catch (e) {
    throw Exception('analytics.dart.getNumberOfEventsHosted: Unknown error $e');
  }
}

Future<int> getTicketsSold(String uid) async {
  final registerUrl = Uri.https(
      APIRoutes.BASE_URL, APIRoutes.getNumberTicketsSold, {"hosterId": uid});
  try {
    final response = await http.get(
      registerUrl,
      headers: APIRoutes.headers,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data.length;
    } else {
      throw Exception(
          'analytics.dart.getTicketsSold: Server returned status code ${response.statusCode}');
    }
  } on SocketException catch (e) {
    throw Exception('analytics.dart.getTicketsSold: Network error $e');
  } on HttpException catch (e) {
    throw Exception('analytics.dart.getTicketsSold: Http Exception error $e');
  } catch (e) {
    throw Exception('analytics.dart.getTicketsSold: Unknown error $e');
  }
}

Future<int> getSubscribers(String uid) async {
  final registerUrl = Uri.https(
      APIRoutes.BASE_URL, APIRoutes.getNumberSubscribers, {"hosterId": uid});
  try {
    final response = await http.get(
      registerUrl,
      headers: APIRoutes.headers,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data.length;
    } else {
      throw Exception(
          'analytics.dart.getSubscribers: Server returned status code ${response.statusCode}');
    }
  } on SocketException catch (e) {
    throw Exception('analytics.dart.getSubscribers: Network error $e');
  } on HttpException catch (e) {
    throw Exception('analytics.dart.getSubscribers: Http Exception error $e');
  } catch (e) {
    throw Exception('analytics.dart.getSubscribers: Unknown error $e');
  }
}

Future<double> getPercentageBeatenBy(String uid, String rankedBy) async {
  final registerUrl = Uri.https(APIRoutes.BASE_URL,
      APIRoutes.getPercentageBeaten, {"hosterId": uid, "rankBy": rankedBy});
  try {
    final response = await http.get(
      registerUrl,
      headers: APIRoutes.headers,
    );

    if (response.statusCode == 200) {
      if (response.body == "\"NaN\"") {
        return 0.0;
      }
      final double data = double.parse(response.body);
      return data;
    } else {
      throw Exception(
          'analytics.dart.getSubscribers: Server returned status code ${response.statusCode}');
    }
  } on SocketException catch (e) {
    throw Exception('analytics.dart.getSubscribers: Network error $e');
  } on HttpException catch (e) {
    throw Exception('analytics.dart.getSubscribers: Http Exception error $e');
  } catch (e) {
    throw Exception('analytics.dart.getSubscribers: Unknown error $e');
  }
}
