import 'package:flutter/material.dart';
import 'package:under_the_c_app/providers/event_providers.dart';

class FilterItem {
  final String name;
  final Icon icon;
  final dynamic value;

  FilterItem({required this.name, required this.icon, required this.value});
}
