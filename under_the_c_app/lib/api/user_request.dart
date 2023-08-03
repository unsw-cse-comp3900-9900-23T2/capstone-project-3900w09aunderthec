import 'dart:convert';
import 'dart:core';
import 'dart:io';

import 'package:under_the_c_app/api/api_routes.dart';
import 'package:under_the_c_app/api/converters/customer_converter.dart';
import 'package:under_the_c_app/config/session_variables.dart';
import 'package:under_the_c_app/types/users/customer_type.dart';
import 'package:http/http.dart' as http;

// Get customer details by their ID
Future<Customer> getCustomerById(String customerId) async {
  final registerUrl = Uri.https(
      APIRoutes.BASE_URL, APIRoutes.getCustomerById, {"id": customerId});
  try {
    final response = await http.get(
      registerUrl,
      headers: APIRoutes.headers,
    );

    if (response.statusCode == 200) {
      // Parse the response body into a list
      final List<dynamic> dataList = jsonDecode(response.body);

      // Check if the list is not empty
      if (dataList.isNotEmpty) {
        // Get the first object from the list
        final Map<String, dynamic> data = dataList[0];
        return backendDataSingleCustomerToCustomer(data);
      } else {
        throw Exception(
            'customer.dart.getEvents: No data returned from server');
      }
    } else {
      throw Exception(
          'customer.dart.getEvents: Server returned status code ${response.statusCode}');
    }
  } on SocketException catch (e) {
    throw Exception('Customer.dart.getCustomers: Network error $e');
  } on HttpException catch (e) {
    throw Exception('Customer.dart.getCustomers: Http Exception error $e');
  } catch (e) {
    throw Exception('Customer.dart.getCustomers: Unknown error $e');
  }
}

// Request made by users to subscribe to a host
Future<void> subscribeHost(int hosterId) async {
  final requestUrl = Uri.https(APIRoutes.BASE_URL, APIRoutes.subscribe);
  try {
    final response = await http.post(
      requestUrl,
      headers: APIRoutes.headers,
      body: jsonEncode({
        "customerId": sessionVariables.uid,
        "hosterId": hosterId,
      }),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(response.body);
    }
  } catch (e) {
    throw Exception(e);
  }
}
