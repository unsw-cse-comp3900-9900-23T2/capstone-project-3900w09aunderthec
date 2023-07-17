// List for Tags
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

import '../../../api/api_routes.dart';
import 'package:http/http.dart' as http;

Future<List<String>> getTags() async {
  final registerUrl = Uri.https(APIRoutes.BASE_URL, APIRoutes.getTags);
  try {
    final response = await http.post(
      registerUrl,
      headers: APIRoutes.headers,
      body: jsonEncode(
        {"title": "string", "description": "string", "venue": "string"},
      ),
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return tagsToList(jsonList);
    } else {
      throw Exception(
          'event.dart.getTags: Server returned status code ${response.statusCode}');
    }
  } on SocketException catch (e) {
    throw Exception('event.dart.getTags: Network error $e');
  } on HttpException catch (e) {
    throw Exception('event.dart.getTags: Http Exception error $e');
  } catch (e) {
    throw Exception('event.dart.getTags: Unknown error $e');
  }
}

List<String> tagsToList(data) {
  List<String> events = [];
  for (var event in data) {
    events.add(event);
  }
  return events;
}

List<DropdownMenuItem<String>> get droppedItems {
  List<DropdownMenuItem<String>> eventType = [
    const DropdownMenuItem(
      value: "Arts",
      child: Text("Arts"),
    ),
    const DropdownMenuItem(
      value: "Business",
      child: Text("Business"),
    ),
    const DropdownMenuItem(
      value: "Comedy",
      child: Text("Comedy"),
    ),
    const DropdownMenuItem(
      value: "Food & Drink",
      child: Text("Food & Drink"),
    ),
    const DropdownMenuItem(
      value: "Fashion",
      child: Text("Fashion"),
    ),
    const DropdownMenuItem(
      value: "Music",
      child: Text("Music"),
    ),
    const DropdownMenuItem(
      value: "Sports",
      child: Text("Sports"),
    ),
    const DropdownMenuItem(
      value: "Science",
      child: Text("Science"),
    ),
    const DropdownMenuItem(
      value: "Other",
      child: Text("Other"),
    ),
  ];
  return eventType;
}
