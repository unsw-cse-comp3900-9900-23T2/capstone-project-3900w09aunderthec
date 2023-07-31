import 'dart:convert';
import 'dart:core';
import 'dart:io';

import 'package:under_the_c_app/api/api_routes.dart';
import 'package:under_the_c_app/api/converters/customer_converter.dart';
import 'package:under_the_c_app/types/users/customer_type.dart';
import 'package:http/http.dart' as http;

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
